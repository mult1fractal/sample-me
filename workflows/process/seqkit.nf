process seqkit {
        label 'seqkit'  
        publishDir "${params.output}/filtered_fastqs/", mode: 'copy', pattern: "${name}_filtered.fastq.gz"
    input:
        tuple val(name), path(fastq)
    output:
        tuple val(name), path("${name}_filtered.fastq.gz") 
    script:
        """
        seqkit seq -m ${params.filter} ${fastq} > ${name}_filtered.fastq
        gzip ${name}_filtered.fastq
        """
}