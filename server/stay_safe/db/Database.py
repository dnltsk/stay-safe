from sqlalchemy.orm import sessionmaker

from db.Model import engine, HistogramOccupancy

Session = sessionmaker(bind=engine)

db_session = Session()

class Database:

    def __init__(self, dbs):
        self.db_session = dbs

    def session(self):
        return self.db_session

    def get_occupancy_at(self, date_time):
        return self.db_session.query(HistogramOccupancy) \
            .filter(HistogramOccupancy.date_time >= date_time) \
            .order_by(HistogramOccupancy.date_time.asc()).first()