require 'pry'

class Student
  attr_accessor(:id,:name,:tagline,:github,:twitter,:blog_url,:image_url,:biography)

  def initialize
    @name = name
    @tagline = tagline
    @github = github
    @twitter = twitter
    @blog_url = blog_url
    @image_url = image_url
    @biography = biography
  end
  
  def self.create_table
    sql = "CREATE TABLE students(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      tagline TEXT,
      github TEXT,
      twitter TEXT,
      blog_url TEXT,
      image_url TEXT,
      biography TEXT);"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def self.new_from_db(row)
    s = Student.new 
    s.id = row[0]
    s.name = row[1]
    s.tagline = row[2]
    s.github = row[3]
    s.twitter = row[4]
    s.blog_url = row[5]
    s.image_url = row[6]
    s.biography = row[7]
    s
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name=?"
    results = DB[:conn].execute(sql,name)
    results.map{|row| self.new_from_db(row)}.first
    # new_results = self.new_from_db(results)
    # new_results
  end

  def insert
    sql = "INSERT INTO students (name,tagline,github,twitter,blog_url,image_url,biography)
    VALUES (?,?,?,?,?,?,?);"
    DB[:conn].execute(sql,@name,@tagline,@github,@twitter,@blog_url,@image_url,@biography)
    update_id = "SELECT last_insert_rowid() FROM students;"
    @id = DB[:conn].execute(update_id).flatten[0]
  end

  def update
    sql= <<-SQL
      UPDATE students 
      SET name=?, tagline=?, github=?, twitter=?, blog_url=? , image_url=?, biography=?
      WHERE id=?
    SQL
    DB[:conn].execute(sql,name, tagline, github, twitter, blog_url , image_url, biography, id)
  end

  def persisted?
    !!id
  end

  def save
    persisted?? self.update : self.insert
  end

end
