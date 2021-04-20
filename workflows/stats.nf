include { readcount } from './process/readcount.nf'

workflow stats_wf {
    take: 
        fastq  
    main:
        fastqcollect = fastq.map { it -> it[1] }. collect()
        fastqcollect.view()
        readcount(fastqcollect)
    emit: readcount.out
} 