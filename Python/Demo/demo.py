# This script is meant to explore some basic Python features used commonly in network automation

# Simple variables

## Integers and Strings and Boolean

i = 2
j = 24

m = 'Hello, world!'

x = i * j

thing = False

# if thing == True:
#     print("It's true")
# if thing == False:
#     print("It's false")

# Complex variables

## Lists and Dictionaries (Hash tables)

even_numbers = ['Mercury', 7, 'Ringo']

planets = ['Mercury', 'Venus', 'Earth', 'Mars', 'Jupiter', 'Saturn', 'Uranus', 'Neptune']

# for item in planets:
#     print("The planet:", item, "is a planet")

starships = {'1701': 'Enterprise', 
             '1864': 'Reliant',
             '1701-D': 'Enterprise',
             '74656': 'Voyager',
             '80102': 'Titan'}

for ship in starships:
    print("NCC-"+ship, "is the USS", starships[ship])

