import sys

Dict={}
with open(sys.argv[1], 'r') as f:
        for line in f:
                line = line.strip()
                query = line.split()[0]
                target = line.split()[1]
                identity = float(line.split()[2])
                if query != target and identity >=30:
                        if query not in Dict and target not in Dict:
                                Dict[query] = target
                                Dict[target] = query
                                print(query+"\t"+target)
