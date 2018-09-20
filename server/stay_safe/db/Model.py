from sqlalchemy import Column, Integer, DateTime, String, create_engine
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class HistogramOccupancy(Base):
    __tablename__ = 'occupancies'

    id = Column(Integer, primary_key=True)
    date_time = Column(DateTime, nullable = False)
    amounts = Column(String, nullable = False)

class Announcement(Base):
    __tablename__ = 'announcements'

    id = Column(Integer, primary_key=True)
    name = Column(String, nullable = False)
    platform = Column(Integer, nullable=False)
    arrival = Column(DateTime, nullable = False)
    amounts = Column(String, nullable=False)


engine = create_engine('sqlite:///database.db', echo=False)

Base.metadata.create_all(engine)