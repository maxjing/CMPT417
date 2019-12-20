# pizza.mzn
     language using: Minizinc
# pizza-optimize-version.mzn
     language using: Minizinc
     Including newly added #10 constraint 
     Including change Paid Set to Array
# generator.py
    A python file to generate .dzn file for pizza solver by running:
    -e.g. python3 generator.py 2 27 5
    -The above command will generate 2 .dnz file each has 27 pizza prices and 5 coupons under the /data folder
# /data
    Contains 10 test which explained in the above testing section
    Once run the generator, newly generated data will be there

