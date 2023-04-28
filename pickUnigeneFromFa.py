import sys

if len(sys.argv) < 2:
	print "* ============================================================"
	print "* Function: pick out a region of unigenes from fasta file"
	print "* Usage: pickUnigeneFromFa.py fastaFile lociInfo"
	print "* Note: lociInfo format: queryGene Begin End"
	print "* ============================================================"
	sys.exit(1)

geneDict={}
name=""; seq=""
fIn=open(sys.argv[1], 'r')
for line in fIn:
	line=line.strip()
	if line[0]=='>':
		if name and seq:
			geneDict[name]=seq
			seq=""
		name=line.replace('>', "")
	else:
		seq+=line

geneDict[name]=seq
		
fIn.close()

fIn2=open(sys.argv[2], 'r')
fOut=open("unigeneQueryOut.fa", 'w')
for line in fIn2:
	line=line.strip()
	queryGene=line.split('\t')[0]
	begin=line.split('\t')[1]
	end=line.split('\t')[2]
       
	lastName=">"+queryGene+"_"+begin+"_"+end
	print queryGene, lastName
	querySeq=geneDict[queryGene][int(begin)-1:int(end)]
	fOut.write("%s\n%s\n" %(lastName, querySeq))

fIn2.close()
fOut.close()

