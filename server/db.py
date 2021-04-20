import sqlite3

def get_db() -> sqlite3.Connection:
    db = sqlite3.connect(
            'data.db',
            detect_types=sqlite3.PARSE_DECLTYPES
        )
    db.row_factory = sqlite3.Row

    return db


def close_db(db):
     if db is not None:
        db.close()


def init_db():
    db = get_db()
    db.execute("DROP TABLE IF EXISTS result_items")
    db.execute("""
CREATE TABLE result_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  result_name TEXT NOT NULL,
  time INTEGER NOT NULL,
  route TEXT NOT NULL,
  map TEXT KEY NOT NULL
);
""")
    db.commit()
    close_db(db)

def add_result_item(result_name, time, route, map_hash):
    db = get_db()
    cursor : sqlite3.Cursor = db.cursor()
    with db:
        cursor.execute("INSERT INTO result_items (result_name, time, route, map) VALUES (?,?,?,?)",
                       (result_name, time, route, map_hash))
        db.commit()
    close_db(db)

def get_result_list(map_hash):
    db = get_db()
    cursor : sqlite3.Cursor = db.cursor()
    res = []
    with db:
        rows = cursor.execute("SELECT * FROM result_items WHERE map = ? ORDER BY time ASC;", [map_hash]).fetchall()
        for r in rows:
            res.append({'name': r['result_name'], 'time': r['time'], 'route': r['route']})
    close_db(db)
    return res


def test_fun():
    add_result_item("Kjell", 1000, "asdasd", "12")
    add_result_item("Kjell", 1000, "asdasd", "12")
    print(get_result_list("12"))