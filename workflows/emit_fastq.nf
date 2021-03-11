process emit_fastq_wf {
        publishDir "${params.output}/fastqs_for_centrifuge", mode: 'copy', pattern: "*.fastq.gz"
        label 'ubuntu'
    input:
        tuple val(name), path(fastq)
    output:
        tuple val(name), path("*.fastq.gz"), emit: reads optional true
    script:
        """
        mv ${fastq} ${name}.fastq.gz
        """

}
