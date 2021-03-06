% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summary.R
\name{fis_summary}
\alias{fis_summary}
\title{Fis summary}
\usage{
fis_summary(data, vcf.metadata = TRUE, whitelist.markers = NULL,
  monomorphic.out = TRUE, snp.ld = NULL, common.markers = TRUE,
  maf.thresholds = NULL, blacklist.id = NULL, pop.levels = NULL,
  pop.labels = NULL, strata = NULL, pop.select = NULL,
  filename = NULL, verbose = FALSE)
}
\arguments{
\item{data}{12 options: VCF (SNPs or Haplotypes,
to make the vcf population ready, see details below),
plink, stacks haplotype file, genind (library(adegenet)),
genlight (library(adegenet)), gtypes (library(strataG)), genepop, DArT,
and a data frame in long/tidy or wide format.
\emph{See details} of \code{\link[radiator]{tidy_genomic_data}}.}

\item{vcf.metadata}{(optional, logical or string) For VCF files only.
With \code{logical, TRUE/FALSE}, \code{vcf.metadata = FALSE}, only the genotype
information is kept (GT field). With \code{vcf.metadata = TRUE},
all the metadata contained in the \code{FORMAT} field will be kept in
the tidy data file. radiator is currently keeping/cleaning only these metadata:
\code{"DP", "AD", "GL", "PL", "GQ", "HQ", "GOF", "NR", "NV"}.
If you need different one, submit a request.
With \code{string}, explicitely ask for a particular FORMAT field you want
to keep (except the GT field that is always imported).
e.g. \code{vcf.metadata = "PL"} or \code{vcf.metadata = c("DP", "GL")}.
Default: \code{vcf.metadata = TRUE}.}

\item{whitelist.markers}{(optional) A whitelist containing CHROM (character
or integer) and/or LOCUS (integer) and/or
POS (integer) columns header. To filter by chromosome and/or locus and/or by snp.
The whitelist is an object in your
global environment or a file in the working directory (e.g. "whitelist.txt").
Note that \emph{de novo} CHROM column with 'un' need to be changed to 1.
In the VCF, the column ID is the LOCUS identification (VCF generated from
stacks have the SNP position on the read embedded in the ID,
so the ID = no longer represent the LOCUS). Marker names are cleaned of
separators that interfere with some packages or codes:
\code{/}, \code{:}, \code{-} and \code{.} are changed to an underscore
\code{_}.
Default \code{whitelist.markers = NULL} for no whitelist of markers.}

\item{monomorphic.out}{(optional) Should the monomorphic
markers present in the dataset be filtered out ?
Default: \code{monomorphic.out = TRUE}.}

\item{snp.ld}{(optional) \strong{For data with locus and SNP info, like VCF and DArT file}.
SNP short distance linkage disequilibrium pruning. With anonymous markers from
RADseq/GBS de novo discovery, you can minimize linkage disequilibrium (LD) by
choosing among these 5 options:
\enumerate{
\item \code{snp.ld = "random"} for a random selection of 1 SNP on the read,
\item \code{snp.ld = "first"} for the first one on the read...,
\item \code{snp.ld = "last"} for the last SNP on the read and
\item \code{snp.ld = "middle"} for locus with > 2 SNPs/read the option to select at random
one SNP between the first and the last SNP on the read. If the locus as <= 2
SNPs on the read, the first one is selected. Note that for that last option,
the numbers are reported.
\item \code{snp.ld = "maf"} will select the SNP on the locus with the maximum global
Minor Allele Frequency (MAF).
}
For long distance linkage disequilibrium pruning, see details below.
Default: \code{snp.ld = NULL}, for no pruning.}

\item{common.markers}{(optional) Logical. Default: \code{common.markers = TRUE},
will only keep markers in common (genotyped) between all the populations.}

\item{maf.thresholds}{(optional) Use for minor allele frequency (maf) or count (mac)
filter. Default: \code{maf.thresholds = NULL}, for no filtering.

String with 5 values.
For example using SNP and frequency approach: \code{maf.thresholds = c("SNP", 0.001, "OR", 0.001, 1)}.
For example using locus and count approach: \code{maf.thresholds = c("locus", 3, "OR", 6, 1)}.
\enumerate{
\item maf approach (character: "SNP"/"locus"):
MAF filtering is conducted by SNPs or locus.
\code{"SNP"}: will consider all the SNPs on the same locus/read as independent
and will be filtered independently of their locus id.
\code{"locus"}: looks at the minimum MAF found on the
read/locus. Using this option will discard all the markers/snp on
that read based on the thresholds chosen. For the locus approach to work, your dataset
requires SNP and Locus info (e.g. from a VCF file).

\item local threshold (double or integer): For a frequency threshold use
a double (e.g. 0.05). For a count threshold, use an integer
(e.g. 3 for the number of alternate allele required in a population). This
threshold is applied by population.
Not sure about the threshold to use, choose the interactive mode argument.

\item operator (character: "OR" / "AND"):
To consider both the local \code{"AND"} the global thresholds, use \code{"AND"}.
To consider the local \code{"OR"} the global thresholds, use \code{"OR"}.

\item global threshold (double or integer): For a frequency threshold
use a double (e.g. 0.02). For a count threshold, use an integer
(e.g. 6 for the number of alternate allele required). This threshold is
applied at the dataset level (no population).
Not sure about the threshold to use, choose the interactive mode argument.

\item maf pop num threshold (integer)
The number of pop required to pass the thresholds
to keep the marker. Usually, I always use \code{1}, for 1 pop is required to
pass thresholds and keep the marker.
}}

\item{blacklist.id}{(optional) A blacklist with individual ID and
a column header 'INDIVIDUALS'. The blacklist is an object in your
global environment or a file in the working directory
(e.g. "blacklist.txt"). \code{_} and \code{:} in individual's names
are changed to a dash \code{-}.
Default: \code{blacklist.id = NULL}.}

\item{pop.levels}{(optional, string) This refers to the levels in a factor. In this
case, the id of the pop.
Use this argument to have the pop ordered your way instead of the default
alphabetical or numerical order. e.g. \code{pop.levels = c("QUE", "ONT", "ALB")}
instead of the default \code{pop.levels = c("ALB", "ONT", "QUE")}.
White spaces in population names are replaced by underscore.
Default: \code{pop.levels = NULL}.}

\item{pop.labels}{(optional, string) Use this argument to rename/relabel
your pop or combine your pop. e.g. To combine \code{"QUE"} and \code{"ONT"}
into a new pop called \code{"NEW"}:
(1) First, define the levels for your pop with \code{pop.levels} argument:
\code{pop.levels = c("QUE", "ONT", "ALB")}.
(2) then, use \code{pop.labels} argument:
\code{pop.labels = c("NEW", "NEW", "ALB")}.
To rename \code{"QUE"} to \code{"TAS"}:
\code{pop.labels = c("TAS", "ONT", "ALB")}.
Default: \code{pop.labels = NULL}. If you find this too complicated,
there is also the \code{strata} argument that can do the same thing,
see below.
White spaces in population names are replaced by underscore.}

\item{strata}{(optional)
The strata file is a tab delimited file with a minimum of 2 columns headers:
\code{INDIVIDUALS} and \code{STRATA}.
If a \code{strata} file is specified with all file formats that don't
require it, the strata argument will have precedence on the population
groupings used internally in those file formats. For file formats without
population/strata groupings (e.g. vcf, haplotype files) if no strata file is
provided, 1 pop/strata grouping will automatically be created.
For vcf and haplotypes file, the strata can also be used as a whitelist of id.
Samples not in the strata file will be discarded from the data set.
The \code{STRATA} column can be any hierarchical grouping.
To create a strata file see \code{\link[radiator]{individuals2strata}}.
If you have already run
\href{http://catchenlab.life.illinois.edu/stacks/}{stacks} on your data,
the strata file is similar to a stacks \emph{population map file},
make sure you
have the required column names (\code{INDIVIDUALS} and \code{STRATA}).
The strata column is cleaned of a white spaces that interfere with some
packages or codes: space is changed to an underscore \code{_}.
Default: \code{strata = NULL}.}

\item{pop.select}{(string, optional) Selected list of populations for
the analysis. e.g. \code{pop.select = c("QUE", "ONT")} to select \code{QUE}
and \code{ONT} population samples (out of 20 pops).
Default: \code{pop.select = NULL}}

\item{filename}{(optional) The function uses \code{\link[fst]{write.fst}},
to write the tidy data frame in
the working directory. The file extension appended to
the \code{filename} provided is \code{.rad}.
With default: \code{filename = NULL}, the tidy data frame is
in the global environment only (i.e. not written in the working directory...).}

\item{verbose}{(optional, logical) When \code{verbose = TRUE}
the function is a little more chatty during execution.
Default: \code{verbose = TRUE}.}
}
\value{
A list with 2 tables: the long format of loci and populations
coverage statistics and the short format by populations.
}
\description{
Fis summary (per markers) by populations and overall.
}
\details{
The tables contains summary statistics (mean, median, min, max).
}
\keyword{internal}
