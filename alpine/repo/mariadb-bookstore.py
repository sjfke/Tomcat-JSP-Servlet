from sqlalchemy import create_engine, text

# engine = create_engine("mysql+pymysql://user:password@localhost:3306/test?charset=utf8mb4")
# engine = create_engine("mysql+pymysql://user:password@mariadb:3306/test?charset=utf8mb4")
engine = create_engine("mysql+pymysql://app:Pastw0rld@dbs:3306/Bookstore?charset=utf8mb4")

# Establish a connection
# connection = engine.connect()
# Close the connection
# connection.close()

with engine.connect() as connection:

    result = connection.execute(text("SELECT * FROM book"))

    for row in result.mappings():
        print(row)