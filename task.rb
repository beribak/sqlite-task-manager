require "sqlite3"
@db = SQLite3::Database.new("tasks.db")
@db.results_as_hash = true

class Task
    @db = SQLite3::Database.new("tasks.db")
    @db.results_as_hash = true
    
    attr_reader :title, :id
    attr_accessor :done, :title
    def initialize(attributes = {})
        @db = SQLite3::Database.new("tasks.db")
        @db.results_as_hash = true
        
        @id = attributes[:id]
        @title = attributes[:title]
        @description = attributes[:description]
        @done = attributes[:done] || false
    end

  # Create / Update
    def save
        if @id.nil?
            # 1. Create
            query = "INSERT INTO tasks (title, description, done) VALUES (?, ?, ?)"
            @db.execute(query, @title, @description, @done)
            @id = @db.last_insert_row_id
        else 
            # 2. Update
            query = "UPDATE tasks SET title = ?, description = ?, done = ? WHERE id = ?"
            @db.execute(query, @title, @description, @done, @id)
        end
    end
  
    # Read
    def self.all
        query = "SELECT * FROM tasks"
        tasks = @db.execute(query)
        arr = []

        tasks.each do |task|
            arr << Task.new(task)
        end

        arr
    end

  # Destroy

  def destroy
    query = "DELETE FROM tasks WHERE id = ?"
    @db.execute(query, @id)
  end
end




