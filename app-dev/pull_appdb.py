import sys
from infradb.app import App

if __name__ == '__main__':

    app = App()
    app.dump_mysql(backup_dir='./')

    sys.exit(0)

