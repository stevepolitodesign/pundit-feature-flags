# Use Pundit as a Rails Feature Flag System 

## Step 1: Initial Setup

This tutorial assumes you are using [devise](https://github.com/heartcombo/devise) and have a `User` model. However, you should still be able to follow along and impliment this pattern even if that's not the case. 

1. Create a `Post` scaffold. 

```
rails g scaffold Post title:string user:references meta_description:text
```

2. Add a `features` column to the `users` table by running the following command.

```
rails g migration add_features_to_users features:jsonb 
```

3. Set a default value on the `features` column.

```ruby

class AddFeaturesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :features, :jsonb, default: {}
  end
end
```

> **What's Going On Here?**
> 
> - In Step 2 we add a [JSONB Column](https://guides.rubyonrails.org/active_record_postgresql.html#json-and-jsonb) to our `users` table. This will allow us to store multiple features in one column, compared to making a ne column for each feature.
> - In Step 3 we add `default: {}` simply to add a formatted deafult value to this column.

4. Run the migrations.

```
rails db:migrate
```

5. Set features on `User` model. 

```ruby
class User < ApplicationRecord
  ...  
  FEATURES = %i[enable_post_meta_description].freeze
  store :features, accessors: User::FEATURES
end
```
