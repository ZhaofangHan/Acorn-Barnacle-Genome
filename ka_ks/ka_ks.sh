## 1. blastp
sh blast.sh

## 2. pick homology gene 
python pickBlast.py blastOut.txt > homology.txt

### 3. ParaAT run
cp ~/bioSoft/ParaAT2.0/proc ./
ParaAT.pl -h homology.txt -n Aam.cds -a Aam.pep -p proc -o output -f axt
cat ./output/*.axt > merge.axt

## 4. KaKs_Calculator
~/bioSoft/KaKs_Calculator2.0/bin/Linux/KaKs_Calculator -i merge.axt -o result.txt

## 5. fitering
awk '{if(NR==1) print $0; else if($6<0.05) print $0}' result.txt > result.filt.txt

## 6. plot density
awk -F "\t" '{print $1"\t"$4}' result.filt.txt > plot.txt
Rscript plot.r plot.txt plot_density.pdf

echo "** finished! **"
