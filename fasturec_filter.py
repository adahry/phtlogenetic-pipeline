import argparse 

parser = argparse.ArgumentParser()

parser.add_argument("path")

args = parser.parse_args()

target_dir = args.path


def substring_before(s, delim):
    return s.partition(delim)[0]

def substring_after(s, delim):
    return s.partition(delim)[2]



with open(target_dir, 'r') as myfile:
  lines = myfile.readlines()


scores = []
for line in lines:
  score = substring_before(line, "(")
  scores.append(score)


nums = [x for x in scores]
my_min = min(nums)

best_tree = lines[scores.index(my_min)+1]
result =substring_after(best_tree, ' ').strip() + ';'.strip()

with open("supertree.txt",'wt') as out_file:
    out_file.write(result)