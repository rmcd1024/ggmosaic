#' Labeling for Mosaic plots.
#'
#' @export
#'
#' @description
#' A mosaic plot with labels
#'
#' @inheritParams ggplot2::layer
#' @param divider Divider function. The default divider function is mosaic() which will use spines in alternating directions. The four options for partitioning:
#' \itemize{
#' \item \code{vspine} Vertical spine partition: width constant, height varies.
#' \item \code{hspine}  Horizontal spine partition: height constant, width varies.
#' \item \code{vbar} Vertical bar partition: height constant, width varies.
#' \item \code{hbar}  Horizontal bar partition: width constant, height varies.
#' }
#' @param offset Set the space between the first spine
#' @param na.rm If \code{FALSE} (the default), removes missing values with a warning. If \code{TRUE} silently removes missing values.
#' @param ... other arguments passed on to \code{layer}. These are often aesthetics, used to set an aesthetic to a fixed value, like \code{color = 'red'} or \code{size = 3}. They may also be parameters to the paired geom/stat.
#' @examples
#' data(titanic)
#'
#' ggplot(data = titanic) +
#'   geom_mosaic(aes(x = product(Class), fill = Survived)) +
#'   geom_mosaic_label(aes(x = product(Class), fill = Survived))
#'
#' ggplot(data = titanic) +
#'   geom_mosaic(aes(x = product(Class, Sex),  fill = Survived),
#'               divider = c("vspine", "hspine", "hspine")) +
#'   geom_mosaic_label(aes(x = product(Class, Sex), fill = Survived),
#'               divider = c("vspine", "hspine", "hspine"), size = 2)
#'
#' ggplot(data = titanic) +
#'   geom_mosaic(aes(x = product(Class), conds = product(Sex),  fill = Survived),
#'               divider = c("vspine", "hspine", "hspine")) +
#'   geom_mosaic_label(aes(x = product(Class), conds = product(Sex), fill = Survived),
#'               divider = c("vspine", "hspine", "hspine"))
geom_mosaic_label <- function(mapping = NULL, data = NULL, stat = "mosaic",
                               position = "identity", na.rm = FALSE,  divider = mosaic(), offset = 0.01,
                               show.legend = NA, inherit.aes = FALSE, ...)
{
  if (!is.null(mapping$y)) {
    stop("stat_mosaic() must not be used with a y aesthetic.", call. = FALSE)
  } else mapping$y <- structure(1L, class = "productlist")

  #  browser()

  aes_x <- mapping$x
  if (!is.null(aes_x)) {
    aes_x <- rlang::eval_tidy(mapping$x)
    var_x <- paste0("x__", as.character(aes_x))
  }

  aes_fill <- mapping$fill
  var_fill <- ""
  if (!is.null(aes_fill)) {
    aes_fill <- rlang::quo_text(mapping$fill)
    var_fill <- paste0("x__fill__", aes_fill)
    if (aes_fill %in% as.character(aes_x)) {
      idx <- which(aes_x == aes_fill)
      var_x[idx] <- var_fill
    } else {
      mapping[[var_fill]] <- mapping$fill
    }
  }

  aes_alpha <- mapping$alpha
  var_alpha <- ""
  if (!is.null(aes_alpha)) {
    aes_alpha <- rlang::quo_text(mapping$alpha)
    var_alpha <- paste0("x__alpha__", aes_alpha)
    if (aes_alpha %in% as.character(aes_x)) {
      idx <- which(aes_x == aes_alpha)
      var_x[idx] <- var_alpha
    } else {
      mapping[[var_alpha]] <- mapping$alpha
    }
  }


  #  aes_x <- mapping$x
  if (!is.null(aes_x)) {
    mapping$x <- structure(1L, class = "productlist")

    for (i in seq_along(var_x)) {
      mapping[[var_x[i]]] <- aes_x[[i]]
    }
  }


  aes_conds <- mapping$conds
  if (!is.null(aes_conds)) {
    aes_conds <- rlang::eval_tidy(mapping$conds)
    mapping$conds <- structure(1L, class = "productlist")
    var_conds <- paste0("conds", seq_along(aes_conds), "__", as.character(aes_conds))
    for (i in seq_along(var_conds)) {
      mapping[[var_conds[i]]] <- aes_conds[[i]]
    }
  }
  ggplot2::layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomMosaicLabel,
    position = position,
    show.legend = show.legend,
    check.aes = FALSE,
    inherit.aes = FALSE, # only FALSE to turn the warning off
    params = list(
      na.rm = na.rm,
      divider = divider,
      offset = offset,
      ...
    )
  )
}

#' Geom proto
#'
#' @format NULL
#' @usage NULL
#' @export
#' @importFrom grid grobTree
#' @importFrom tidyr nest unnest
#' @importFrom dplyr mutate select
GeomMosaicLabel <- ggplot2::ggproto(
  "GeomMosaicLabel", ggplot2::Geom,
  setup_data = function(data, params) {
    #cat("setup_data in GeomMosaic\n")
    #browser()
    data
  },
  required_aes = c("xmin", "xmax", "ymin", "ymax"),
  default_aes = ggplot2::aes(width = 0.1, linetype = "solid", size=2.7,
                             shape = 19, colour = "black",
                             fill = "grey30", alpha = 1, stroke = 0.1,
                             linewidth=.1, weight = 1, x = NULL, y = NULL, conds = NULL),

  draw_panel = function(data, panel_scales, coord) {
    #cat("draw_panel in GeomMosaic\n")
    #browser()
    if (all(is.na(data$colour)))
      data$colour <- scales::alpha(data$fill, data$alpha) # regard alpha in colour determination

    sub <- subset(data, level==max(data$level))
    text <- sub
    text <- tidyr::nest(text, -label)

    text <-
      dplyr::mutate(
        text,
        coords = purrr::map(data, .f = function(d) {
          data.frame(
            x = (d$xmin + d$xmax)/2,
            y = (d$ymin + d$ymax)/2,
            #size = 2.88,
            angle = 0,
            hjust = 0.5,
            vjust = 0.5,
            alpha = NA,
            family = "",
            fontface = 1,
            lineheight = 1.2,
            dplyr::select(d, -x, -y, size, -alpha)
          )
        })
      )

    text <- tidyr::unnest(text, coords)

    sub$fill <- NA
    sub$colour <- NA
    sub$size <- sub$size/10
    ggplot2:::ggname("geom_mosaic_label", grobTree(
      GeomRect$draw_panel(sub, panel_scales, coord),
      GeomText$draw_panel(text, panel_scales, coord)
    ))
  },

  check_aesthetics = function(x, n) {
    #browser()
    ns <- vapply(x, length, numeric(1))
    good <- ns == 1L | ns == n


    if (all(good)) {
      return()
    }

    stop(
      "Aesthetics must be either length 1 or the same as the data (", n, "): ",
      paste(names(!good), collapse = ", "),
      call. = FALSE
    )
  },

  draw_key = ggplot2::draw_key_rect
)



