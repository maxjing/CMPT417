import sys
from pymzn import dzn
import numpy as np

fileNamePre = 'pizza-data-'


def makeFile(nfiles, n, m):
    for i in range(1, int(nfiles) + 1):
        price = np.random.randint(10, 100, int(n))
        buy = np.random.randint(1, 10, int(m))
        free = np.random.randint(1, 10, int(m))
        data = {
            "n": n,
            "price": price,
            "m": m,
            "buy": buy,
            "free": free
        }
        with open(f'data/{fileNamePre}{i + 10}.dzn', "w") as f:
            f.write("\n".join(dzn.dict2dzn(data)))


def main():
    nfiles = sys.argv[1]
    n = sys.argv[2]
    m = sys.argv[3]
    makeFile(nfiles, n, m)


if __name__ == '__main__':
    main()
