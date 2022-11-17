#!/bin/bash 

help="Download mash sketches and merge them for homopolish.
    -o, --out_dir | directory to save sketches
"

while [ "$1" != "" ]; do
    case $1 in
        -o | --out_dir  )           shift
                         out_dir=$1
                         ;;
        -h | --help )    echo "$help"
                         exit 1
                         ;;
        * )              echo "$help"
                         exit 1
    esac
    shift
done

mkdir -p $out_dir
cd $out_dir

echo "Fetching bacteria sketches..."
curl -o - http://bioinfo.cs.ccu.edu.tw/bioinfo/mash_sketches/bacteria.msh.gz | gunzip > bacteria.msh
echo "Fetching virus sketches..."
curl -o - http://bioinfo.cs.ccu.edu.tw/bioinfo/mash_sketches/virus.msh.gz | gunzip > virus.msh
echo "Fetching fungi sketches..."
curl -o - http://bioinfo.cs.ccu.edu.tw/bioinfo/mash_sketches/fungi.msh.gz | gunzip > fungi.msh

echo "Pasting all sketches to genomes.msh"
mash paste genomes.msh bacteria.msh virus.msh fungi.msh
rm bacteria.msh virus.msh fungi.msh

echo "Finished"