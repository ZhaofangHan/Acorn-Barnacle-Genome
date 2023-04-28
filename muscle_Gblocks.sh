for i in  `ls ../SingleCopyOrthologGroups/*.fasta | sed 's/..\/SingleCopyOrthologGroups\///g'`
do
	echo $i 
	/public/tools/alignment/muscle-3.8.1551/muscle -in ../SingleCopyOrthologGroups/${i} -out ${i}.1
	~/bioSoft/Gblocks_0.91b/Gblocks ${i}.1 -b4=5 -b5=h -e=.2

	seqkit sort ${i}.1.2 > ${i}.1.2.3
	seqkit seq ${i}.1.2.3 -w 0 > ${i}.1.2.3.4
done

paste -d " " *.4 > all.fa
