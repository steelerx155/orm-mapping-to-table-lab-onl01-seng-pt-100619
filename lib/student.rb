class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end
  
  def self.create_table
  sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  
  def self.create(name, grade)
    {name => "Sally" 
    student = Student.new(id)
    student.save
    student
  end
end





describe ".create" do
    before(:each) do
      Student.create_table
    end
    it 'takes in a hash of attributes and uses metaprogramming to create a new student object. Then it uses the #save method to save that student to the database' do
      Student.create(name: "Sally", grade: "10th")
      expect(DB[:conn].execute("SELECT * FROM students")).to eq([[1, "Sally", "10th"]])
    end
    it 'returns the new object that it instantiated' do
      student = Student.create(name: "Josh", grade: "9th")
      expect(student).to be_a(Student)
      expect(student.name).to eq("Josh")
      expect(student.grade).to eq("9th")
    end
  end
end

