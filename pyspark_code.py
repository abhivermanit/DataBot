# Python program to find the most repeated word 
# in a text file

# A file named "gfg", will be opened with the 
# reading mode.
file = open("gfg.txt","r")
frequent_word = ""
frequency = 0
words = []

# Traversing file line by line 
for line in file:
	
	# splits each line into
	# words and removing spaces 
	# and punctuations from the input
	line_word = line.lower().replace(',','').replace('.','').split(" "); 
	
	# Adding them to list words
	for w in line_word: 
		words.append(w); 
		
# Finding the max occurred word
for i in range(0, len(words)): 
	
	# Declaring count
	count = 1; 
	
	# Count each word in the file 
	for j in range(i+1, len(words)): 
		if(words[i] == words[j]): 
			count = count + 1; 

	# If the count value is more
	# than highest frequency then
	if(count > frequency): 
		frequency = count; 
		frequent_word = words[i]; 

print("Most repeated word: " + frequent_word)
print("Frequency: " + str(frequency))
file.close();

# The above is a python program now if we convert this to pyspark 

from pyspark import SparkContext

sc = SparkContext("local", "WordCountApp")

# Read the file into an RDD
lines = sc.textFile("gfg.txt")

# Split lines into words, remove punctuation, and make lowercase
words = lines.flatMap(lambda line: line.lower().replace(',', '').replace('.', '').split())

# Map each word to a tuple (word, 1)
word_pairs = words.map(lambda word: (word, 1))

# Reduce by key (word) to count frequencies
word_counts = word_pairs.reduceByKey(lambda a, b: a + b)

# Find the most frequent word
most_frequent = word_counts.takeOrdered(1, key=lambda x: -x[1])

print("Most repeated word:", most_frequent[0][0])
print("Frequency:", most_frequent[0][1])

sc.stop()


















