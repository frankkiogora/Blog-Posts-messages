|     Project | Information                                                     |
|------------:|:----------------------------------------------------------------|
| Domain:     | [Coding Dojo](http://codingdojo.com) (cd)                       |
| Topic:      | Ruby on Rails (ror) <br> Understanding Rails - Models (02model) |
| Assignment: | Blogs/Posts/Messages #2 (04blog2)                               |
| Repository: | cd-ror-02model-04blog2                                          |

~~~

---------------
#1: Start a new project
---------------

rails new blog-post-message2
cd blog-post-message2

edit> Gemfile
  gem 'bcrypt', '~> 3.1.7'    # Using bcrypt (3.1.7)
  gem 'foundation-rails'      # Using foundation-rails (5.4.0.0)
  gem 'hirb'                  # Using hirb (0.7.2)
bundle install

---------------
#2: Create appropriate models/tables using "rails generate model", "rake db:create", and "rake db:migrate"
---------------

rails g model Blog name:string description:text 
rails g model Post title:string content:text blog:references user:references 
rails g model Message author:string message:text post:references user:references
rails g model User first_name:string last_name:string email_address:string
rails g model Owner user:references blog:references

# The Owner model will refer to user and blog. User can 
# have many owners, which means a user can own multiple blogs. 
# And blog can also have many owners.

rake db:migrate

edit> blog.rb
class Blog < ActiveRecord::Base
    has_many :posts
    has_many :messages, through: :posts
    has_many :owners
    has_many :users, through: :owners

    validates :name, :description, presence: true
end

edit> post.rb
class Post < ActiveRecord::Base
  belongs_to :blog
  belongs_to :user

  has_many :messages

  validates :title, :content, presence: true
  validates :title, :length => { :minimum => 7}
end

edit> message.rb
class Message < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates :author, :message, presence: true
  validates :message, :length => { :minimum => 15}
end

edit> user.rb
class User < ActiveRecord::Base
    has_many :messages
    has_many :owners
    has_many :posts
    has_many :blogs, through: :owners

    EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
    validates :email_address, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }
end

edit> owner.rb
class Owner < ActiveRecord::Base
  belongs_to :user
  belongs_to :blog
end

---------------
#3: Verify tables structures
---------------
rails c
Hirb.enable()

Blog.new
+----+------+-------------+------------+------------+
| id | name | description | created_at | updated_at |
+----+------+-------------+------------+------------+
|    |      |             |            |            |
+----+------+-------------+------------+------------+

Post.new
+----+-------+---------+---------+---------+------------+------------+
| id | title | content | blog_id | user_id | created_at | updated_at |
+----+-------+---------+---------+---------+------------+------------+
|    |       |         |         |         |            |            |
+----+-------+---------+---------+---------+------------+------------+

Message.new
+----+--------+---------+---------+---------+------------+------------+
| id | author | message | post_id | user_id | created_at | updated_at |
+----+--------+---------+---------+---------+------------+------------+
|    |        |         |         |         |            |            |
+----+--------+---------+---------+---------+------------+------------+

User.new
+----+------------+-----------+---------------+------------+------------+
| id | first_name | last_name | email_address | created_at | updated_at |
+----+------------+-----------+---------------+------------+------------+
|    |            |           |               |            |            |
+----+------------+-----------+---------------+------------+------------+

Owner.new
+----+---------+---------+------------+------------+
| id | user_id | blog_id | created_at | updated_at |
+----+---------+---------+------------+------------+
|    |         |         |            |            |
+----+---------+---------+------------+------------+

---------------
#4.1: Be able to create 5 users
---------------

User.create(first_name: "User 1 first_name", last_name: "User 1 last_name", email_address: "user1@aol.com")
User.create(first_name: "User 2 first_name", last_name: "User 2 last_name", email_address: "user2@aol.com")
User.create(first_name: "User 3 first_name", last_name: "User 3 last_name", email_address: "user3@aol.com")
User.create(first_name: "User 4 first_name", last_name: "User 4 last_name", email_address: "user4@aol.com")
User.create(first_name: "User 5 first_name", last_name: "User 5 last_name", email_address: "user5@aol.com")

User.all
+----+-------------------+------------------+---------------+-------------------------+-------------------------+
| id | first_name        | last_name        | email_address | created_at              | updated_at              |
+----+-------------------+------------------+---------------+-------------------------+-------------------------+
| 1  | User 1 first_name | User 1 last_name | user1@aol.com | 2014-08-26 13:24:58 UTC | 2014-08-26 13:24:58 UTC |
| 2  | User 2 first_name | User 2 last_name | user2@aol.com | 2014-08-26 13:24:58 UTC | 2014-08-26 13:24:58 UTC |
| 3  | User 3 first_name | User 3 last_name | user3@aol.com | 2014-08-26 13:24:58 UTC | 2014-08-26 13:24:58 UTC |
| 4  | User 4 first_name | User 4 last_name | user4@aol.com | 2014-08-26 13:24:58 UTC | 2014-08-26 13:24:58 UTC |
| 5  | User 5 first_name | User 5 last_name | user5@aol.com | 2014-08-26 13:24:58 UTC | 2014-08-26 13:24:58 UTC |
+----+-------------------+------------------+---------------+-------------------------+-------------------------+

---------------
#4.2: Be able to create 5 blogs
---------------

Blog.create(name: "Blog 1 name", description: "Blog 1 description")
Blog.create(name: "Blog 2 name", description: "Blog 2 description")
Blog.create(name: "Blog 3 name", description: "Blog 3 description")
Blog.create(name: "Blog 4 name", description: "Blog 4 description")
Blog.create(name: "Blog 5 name", description: "Blog 5 description")

Blog.all
+----+-------------+--------------------+-------------------------+-------------------------+
| id | name        | description        | created_at              | updated_at              |
+----+-------------+--------------------+-------------------------+-------------------------+
| 1  | Blog 1 name | Blog 1 description | 2014-08-26 13:26:29 UTC | 2014-08-26 13:26:29 UTC |
| 2  | Blog 2 name | Blog 2 description | 2014-08-26 13:26:29 UTC | 2014-08-26 13:26:29 UTC |
| 3  | Blog 3 name | Blog 3 description | 2014-08-26 13:26:29 UTC | 2014-08-26 13:26:29 UTC |
| 4  | Blog 4 name | Blog 4 description | 2014-08-26 13:26:29 UTC | 2014-08-26 13:26:29 UTC |
| 5  | Blog 5 name | Blog 5 description | 2014-08-26 13:26:29 UTC | 2014-08-26 13:26:29 UTC |
+----+-------------+--------------------+-------------------------+-------------------------+

---------------
#4.3: To add the first user to the last blog, you would do the following: 
      User.first.blogs = [Blog.last]

      To add both the first and the last blog to the first user, you would do 
      User.first.blogs = [Blog.first, Blog.last]

      What would you do to add the second and third user to the second blog?
---------------


sql = "select * from owners"
results = ActiveRecord::Base.connection.execute(sql)

sql = "ALTER TABLE owners AUTO_INCREMENT = 1"
results = ActiveRecord::Base.connection.execute(sql)

sqlite = "UPDATE SQLITE_SEQUENCE SET SEQ=0 WHERE NAME='owners'"
results = ActiveRecord::Base.connection.execute(sqlite)

sqlite = "select * from SQLITE_SEQUENCE"
results = ActiveRecord::Base.connection.execute(sqlite)

*** From Ruby setup-info.txt document 
  Blog.column_names   # list column names
  Blog.new            # create new object and display as table
  Blog.all            # display all records
  ActiveRecord::Base.connection.tables
                      # list all tables
  ActiveRecord::Base.connection.execute("select * from blogs")
                      # lists all field names and their values
  ActiveRecord::Base.connection.execute("SELECT * FROM sqlite_master")
                      # lists create statements for all tables
  ActiveRecord::Base.connection.execute("SELECT sql FROM sqlite_master WHERE name = 'blogs'")
                      # lists create statement for individual table
***

--------------------------------------------------------
Add the first user to the last blog.
--------------------------------------------------------

table   user_id   blog_id
owner   1         5         

Answer: User.first.blogs = [Blog.last]

Owner.all
+----+---------+---------+-------------------------+-------------------------+
| id | user_id | blog_id | created_at              | updated_at              |
+----+---------+---------+-------------------------+-------------------------+
| 1  | 1       | 5       | 2014-08-26 15:17:57 UTC | 2014-08-26 15:17:57 UTC |
+----+---------+---------+-------------------------+-------------------------+

--------------------------------------------------------
Add both the first and the last blog to the first user.
--------------------------------------------------------    

table    user_id   blog_id
owners   1         1
         1         5

Answer: User.first.blogs = [Blog.first, Blog.last]

Owner.all
+----+---------+---------+-------------------------+-------------------------+
| id | user_id | blog_id | created_at              | updated_at              |
+----+---------+---------+-------------------------+-------------------------+
| 1  | 1       | 5       | 2014-08-26 15:17:57 UTC | 2014-08-26 15:17:57 UTC |
| 2  | 1       | 1       | 2014-08-26 15:18:53 UTC | 2014-08-26 15:18:53 UTC |
+----+---------+---------+-------------------------+-------------------------+

-------------------------------------------------
Add the second and third user to the second blog.
-------------------------------------------------

table    user_id   blog_id
owners   2         2
         3         2

Answer: Blog.second.users = [User.find(2), User.find(3)]

    or
        User.find(2).blogs = [Blog.find(2)]
        User.find(3).blogs  = [Blog.find(2)]

    or

        # Assume we don't know the ID of the second blog, 
        blogs = Blog.limit(2) # We limit the results for blogs to 2 to be able to get the second blog
        users = User.limit(3) # We limit the results for users to 3 to be able to get the second and third user
        blogs.last.users = [users[1], users[2]] # We used the users array to be able to retrieve the second and third user

Owner.all
+----+---------+---------+-------------------------+-------------------------+
| id | user_id | blog_id | created_at              | updated_at              |
+----+---------+---------+-------------------------+-------------------------+
| 1  | 1       | 5       | 2014-08-26 15:17:57 UTC | 2014-08-26 15:17:57 UTC |
| 2  | 1       | 1       | 2014-08-26 15:18:53 UTC | 2014-08-26 15:18:53 UTC |
| 3  | 2       | 2       | 2014-08-26 15:37:07 UTC | 2014-08-26 15:37:07 UTC |
| 4  | 3       | 2       | 2014-08-26 15:37:07 UTC | 2014-08-26 15:37:07 UTC |
+----+---------+---------+-------------------------+-------------------------+
 
---------------
#4.4: Have the first user create 3 posts, assign the first 2 posts to the first
      blog and the last post to the last blog
---------------

User.find(1).posts.create(title: "User 1 Post 1 title", content: "User 1 Post 1 content")
User.find(1).posts.create(title: "User 1 Post 2 title", content: "User 1 Post 2 content")
User.find(1).posts.create(title: "User 1 Post 3 title", content: "User 1 Post 3 content")

table   blog_id   user_id
posts   1         1
        1         1
        5         1
        
Answer: Blog.first.posts = [Post.first, Post.second]
        Blog.last.posts = [Post.last]

        or

        # Assign the first 2 posts to the first blog
        first_user_posts = User.first.posts.limit(2)
        Blog.first.posts = [first_user_posts.first, first_user_posts.last]

        # Assign the last post to the last blog
        Blog.last.posts = [Post.last]

Post.all
+----+---------------------+-----------------------+---------+---------+-------------------------+-------------------------+
| id | title               | content               | blog_id | user_id | created_at              | updated_at              |
+----+---------------------+-----------------------+---------+---------+-------------------------+-------------------------+
| 1  | User 1 Post 1 title | User 1 Post 1 content | 1       | 1       | 2014-08-26 15:49:29 UTC | 2014-08-26 15:50:26 UTC |
| 2  | User 1 Post 2 title | User 1 Post 2 content | 1       | 1       | 2014-08-26 15:49:29 UTC | 2014-08-26 15:50:26 UTC |
| 3  | User 1 Post 3 title | User 1 Post 3 content | 5       | 1       | 2014-08-26 15:49:29 UTC | 2014-08-26 15:50:43 UTC |
+----+---------------------+-----------------------+---------+---------+-------------------------+-------------------------+

---------------
#4.5.1 You can create a new blog for the first user by calling: 
       "User.first.blogs.create(:name => "New Blog", :description => "New Description")". 
---------------

table    user_id   blog_id
owners   1         6

Answer: User.first.blogs.create(:name => "New Blog", :description => "New Description")

Blog.all
+----+-------------+--------------------+-------------------------+-------------------------+
| id | name        | description        | created_at              | updated_at              |
+----+-------------+--------------------+-------------------------+-------------------------+
| 1  | Blog 1 name | Blog 1 description | 2014-08-26 13:26:29 UTC | 2014-08-26 13:26:29 UTC |
| 2  | Blog 2 name | Blog 2 description | 2014-08-26 13:26:29 UTC | 2014-08-26 13:26:29 UTC |
| 3  | Blog 3 name | Blog 3 description | 2014-08-26 13:26:29 UTC | 2014-08-26 13:26:29 UTC |
| 4  | Blog 4 name | Blog 4 description | 2014-08-26 13:26:29 UTC | 2014-08-26 13:26:29 UTC |
| 5  | Blog 5 name | Blog 5 description | 2014-08-26 13:26:29 UTC | 2014-08-26 13:26:29 UTC |
| 6  | New Blog    | New Description    | 2014-08-26 16:05:44 UTC | 2014-08-26 16:05:44 UTC |
+----+-------------+--------------------+-------------------------+-------------------------+

Owner.all
+----+---------+---------+-------------------------+-------------------------+
| id | user_id | blog_id | created_at              | updated_at              |
+----+---------+---------+-------------------------+-------------------------+
| 1  | 1       | 5       | 2014-08-26 15:17:57 UTC | 2014-08-26 15:17:57 UTC |
| 2  | 1       | 1       | 2014-08-26 15:18:53 UTC | 2014-08-26 15:18:53 UTC |
| 3  | 2       | 2       | 2014-08-26 15:37:07 UTC | 2014-08-26 15:37:07 UTC |
| 4  | 3       | 2       | 2014-08-26 15:37:07 UTC | 2014-08-26 15:37:07 UTC |
| 5  | 1       | 6       | 2014-08-26 16:05:44 UTC | 2014-08-26 16:05:44 UTC |
+----+---------+---------+-------------------------+-------------------------+

---------------
#4.5.2: How would you create a new post that belongs to the second blog? 
        How would you indicate that this new post was created by the first user?
---------------
Blog.find(2).posts.create(title: "New Post", content: "Belongs to 2nd Blog, created by 1st User")
Post.last.update(user_id: 1)

or 

User.first.posts.create(title: "New Post", content: "Belongs to 2nd Blog, created by 1st User")
Blog.find(2).posts = [Post.last]


Post.all
+----+---------------------+------------------------------------------+---------+---------+-------------------------+-------------------------+
| id | title               | content                                  | blog_id | user_id | created_at              | updated_at              |
+----+---------------------+------------------------------------------+---------+---------+-------------------------+-------------------------+
| 1  | User 1 Post 1 title | User 1 Post 1 content                    | 1       | 1       | 2014-08-26 15:49:29 UTC | 2014-08-26 21:03:10 UTC |
| 2  | User 1 Post 2 title | User 1 Post 2 content                    | 1       | 1       | 2014-08-26 15:49:29 UTC | 2014-08-26 21:00:06 UTC |
| 3  | User 1 Post 3 title | User 1 Post 3 content                    | 5       | 1       | 2014-08-26 15:49:29 UTC | 2014-08-26 21:00:51 UTC |
| 4  | New Post            | Belongs to 2nd Blog, created by 1st User | 2       | 1       | 2014-08-26 16:45:27 UTC | 2014-08-26 20:57:20 UTC |
+----+---------------------+------------------------------------------+---------+---------+-------------------------+-------------------------+

---------------
#4.6.1: Retrieve the user that owns the post id 1 
---------------

Post.find(1).user
+----+-------------------+------------------+---------------+-------------------------+-------------------------+
| id | first_name        | last_name        | email_address | created_at              | updated_at              |
+----+-------------------+------------------+---------------+-------------------------+-------------------------+
| 1  | User 1 first_name | User 1 last_name | user1@aol.com | 2014-08-26 13:24:58 UTC | 2014-08-26 13:24:58 UTC |
+----+-------------------+------------------+---------------+-------------------------+-------------------------+

---------------
#4.7: Be able to create messages written by the second user in any post (i.e. 1st Blog 1st Post)
---------------

u = User.find(2).messages.create(author: "Ben Tiddle", message: "This is another great message")
u.post = Blog.find(1).posts.first
u.save

NOTE: The answer sheet solution (below) didn't work. Trey's response is that one step chaining sometimes just doesn't work with Active Response. Do the two step instead.

users = User.limit(2)
users.last.blogs.first.posts.first.messages.create(:author => "a different author", :message => "A new message that is written by a different author").errors.full_messages

---------------
#4.8: Be able to retrieve all messages from any specific post (i.e. the first post)
---------------

Post.first.messages

---------------
#4.9: Be able to retrieve all the users that "own" any specific blog
---------------

Blog.first.users

---------------
The End!
---------------

~~~
