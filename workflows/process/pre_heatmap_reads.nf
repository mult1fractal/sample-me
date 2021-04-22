process pre_heatmap_reads {
    publishDir "${params.output}/stats/", mode: 'copy', pattern: "*.csv"
    label 'R_plot'
    input:
        path(read_until)
    output:
        path("*.csv")
    script:
        """
        bash pre_heatmap_reads.sh
        """
}