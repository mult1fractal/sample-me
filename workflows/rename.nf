process rename {
    label 'ubuntu'
    input:
        tuple val(name), path(fastq)       
    output:
        tuple val(name), path("*.fastq.gz")
    script:
        """
        mv ${fastq} ${name}.fastq.gz
        """
}