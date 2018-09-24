from datetime import datetime, timedelta, time
from threading import Thread
from time import sleep

from db.Database import db_session, Database
from timetable.Timetable import Timetable
from web.RESTEngine import RESTEngine


def threaded_fun(tt):
    interval = 30

    while True:
        #tt.update(now)
        sleep(interval)
        #now = now + timedelta(seconds=interval)

def main():
    database = Database(db_session)
    timetable = Timetable(database)

    t1 = Thread(target=threaded_fun, args=(timetable,))
    t1.start()


    rest_engine = RESTEngine(database, timetable)
    rest_engine.run()



if __name__ == "__main__":
    main()
