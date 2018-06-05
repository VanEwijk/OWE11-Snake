
######## Snakemake header ########
library(methods)
Snakemake <- setClass(
    "Snakemake",
    slots = c(
        input = "list",
        output = "list",
        params = "list",
        wildcards = "list",
        threads = "numeric",
        log = "list",
        resources = "list",
        config = "list",
        rule = "character"
    )
)
snakemake <- Snakemake(
    input = list('RNAseq.txt'),
    output = list('RNAseq_acc.txt', 'NCBI_tags.txt'),
    params = list(),
    wildcards = list(),
    threads = 1,
    log = list(),
    resources = list(),
    config = list(),
    rule = 'entrezID'
)
######## Original script #########
RNAseq <- snakemake@input[[1]]
library(rentrez)
RNAseq <- read.delim(RNAseq)

locus_tags <- RNAseq[,1]
locus_tags <- paste0(locus_tags,"[GENE]")

NCBI_tags <- c()

for (tags in locus_tags) {
  
  r_search <- entrez_search(db = "gene", term = tags)
  NCBI_tags <-c(NCBI_tags, r_search$ids)
}

RNAseq$NCBI_tags <- NCBI_tags

write.table(RNAseq, "RNAseq_acc.txt", sep=";", row.names = FALSE)
write(NCBI_tags, "NCBI_tags.txt")

RNAseq_acc.txt  <- snakemake@output[[1]]
NCBI_tags.txt <- snakemake@output[[2]]
