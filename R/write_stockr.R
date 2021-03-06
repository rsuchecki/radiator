# write a stockR data set
#' @name write_stockr
#' @title Write a stockR dataset from a tidy data frame

#' @description Write a stockR dataset (Fost et al. submitted) from a tidy data frame.
#' Used internally in \href{https://github.com/thierrygosselin/radiator}{radiator}
#' and might be of interest for users.

#' @param data A tidy data frame object in the global environment or
#' a tidy data frame in wide or long format in the working directory.
#' \emph{How to get a tidy data frame ?}
#' Look into \pkg{radiator} \code{\link{tidy_genomic_data}}.

#' @export
#' @rdname write_stockr

#' @importFrom dplyr select distinct n_distinct group_by ungroup rename arrange tally filter if_else mutate summarise left_join inner_join right_join anti_join semi_join full_join desc
#' @importFrom stringi stri_join stri_replace_all_fixed stri_sub stri_pad_left
#' @importFrom tidyr spread gather unite
#' @importFrom readr write_delim

#' @references Foster et al. submitted

#' @return The object generated is a matrix with
#' dimension: MARKERS x INDIVIDUALS. The genotypes are coded like PLINK:
#' 0, 1 or 2 alternate allele. 0: homozygote for the reference allele,
#' 1: heterozygote, 2: homozygote for the alternate allele.
#' Missing genotypes have NA. The object also as 2 attributes.
#' \code{attributes(data)$grps} with \code{STRATA/POP_ID} of the individuals and
#' \code{attributes(data)$sample.grps} filled with \code{INDIVIDUALS}.
#' Both attributes can be used inside \emph{stockR}.

#' @author Thierry Gosselin \email{thierrygosselin@@icloud.com}

write_stockr <- function(data) {
  if (is.vector(data)) {
    data <- radiator::tidy_wide(data = data, import.metadata = TRUE)
  }

  data <- dplyr::select(data, MARKERS, POP_ID, INDIVIDUALS, GT_BIN) %>%
    dplyr::arrange(MARKERS, POP_ID, INDIVIDUALS)
  strata <- dplyr::distinct(data, INDIVIDUALS, POP_ID)

  data <- suppressWarnings(dplyr::select(data, MARKERS, INDIVIDUALS, GT_BIN) %>%
    data.table::as.data.table(.) %>%
    data.table::dcast.data.table(
      data = .,
      formula = MARKERS ~ INDIVIDUALS,
      value.var = "GT_BIN"
    ) %>%
    tibble::as_data_frame(.) %>%
    dplyr::select(MARKERS, strata$INDIVIDUALS) %>%
    tibble::remove_rownames(.) %>%
    tibble::column_to_rownames(df = ., var = "MARKERS")) %>%
    as.matrix(.)

  attr(data,"grps") <- strata$POP_ID
  attr(data,"sample.grps") <- factor(strata$INDIVIDUALS)

return(data)

} # end write_stockr
