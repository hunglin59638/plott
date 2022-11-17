process filtlong {

    input:
        path read
    
    output:
        path 'filtlong.fq'
    
    script:
    """
    filtlong --min_length 1000 $read > filtlong.fq
    """

}

process porechop {

    input:
        path read
    
    output:
        path 'trim.fq'
    
    script:
    """
    porechop --discard_middle -i $read -o trim.fq --threads $task.cpus
    """

}

process flye {
    input:
        path read
        val read_source
        val is_meta
    
    output:
        path 'flye_out/assembly.fasta'

    script:
    def add_meta = is_meta ? "--meta" : ''
    """
    flye --threads $task.cpus --out-dir flye_out --plasmids $add_meta --iterations 2 --$read_source $read
    """
    

}

process racon {
    input:
        path reads
        path target

    output:
        path 'polish.fasta'
    
    script:
        """
        minimap2 -t $task.cpus -o overlap.paf $target $reads 
        racon -t $task.cpus $reads overlap.paf $target > polish.fasta
        """

}


process racon_sec {
    input:
        path reads
        path target

    output:
        path 'polish_sec.fasta'
    
    script:
        """
        minimap2 -t $task.cpus -o overlap.paf $target $reads 
        racon -t $task.cpus $reads overlap.paf $target > polish_sec.fasta
        """

}

process medaka_consensus {
    input:
        path basecalls
        path draft
    output:
        path 'medaka_out/consensus.fasta'
    
    script:
        """
        medaka_consensus -i $basecalls -d $draft -o medaka_out -t $task.cpus -m r941_min_high_g303
        """

}

process homopolish {
    input:
        path genome
        path sketches
    output:
        path "polish_out/${genome.baseName}_homopolished.fasta"

    script:
        """
        homopolish polish -t $task.cpus -a $genome -s $sketches -m R9.4.pkl -o polish_out
        """

}

process publish {
    input:
        path input_file
        val out_dir
    
    script:
        """
        python $projectDir/scripts/copy_to_output.py $input_file $out_dir
        """

}

process foo {
    publishDir "results", mode: 'symlink'

    output:
    path 'output_file.txt' into result_ch

    script:
    """
    echo my_command --this > output_file.txt
    """

}