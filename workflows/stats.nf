include { readcount } from './process/readcount.nf'
include { pavian_metrics } from './process/pavian_metrics.nf'
include { pre_heatmap_reads } from './process/pre_heatmap_reads.nf'
include { heatmap_reads } from './process/heatmap_reads.nf'
include { boxplot } from './process/boxplot.nf'
include { nanoplot } from './process/nanoplot'

workflow stats_wf {
    take: 
        fastq
        pavian_reports
    main:
        
        nanoplot(fastq)//.flatten().map { it -> [ it.simpleName, it[2] ] }
        nanoplot.out.view()
        // map fastqs to path only
        fastqcollect = fastq.map { it -> it[1] }.collect()
        readcount(fastqcollect)

         if ( params.pavian_metrics ) { 
            // map reports to path only
            pavian_reports_collect = pavian_reports.map { it -> it[1] }.collect()
            pavian_metrics(pavian_reports_collect)
         }
        // baloonplot and heatmap of reads
        heatmap_reads(pre_heatmap_reads(pavian_reports_collect))
        
        // boxplot 
        boxplot(readcount.out)




    emit: readcount.out//, pavian_metrics.out
}