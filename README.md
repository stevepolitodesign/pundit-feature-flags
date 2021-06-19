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
> - We add a [JSONB Column](https://guides.rubyonrails.org/active_record_postgresql.html#json-and-jsonb) to our `users` table. This will allow us to store multiple features in one column, compared to making a column for each feature.
> - We add `default: {}` simply to add a formatted deafult value to this column.

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

> **What's Going On Here?**
> 
> - We create a `FEATURES` constant that will store the names of our features as symbols by calling `%i` on the array. We call `.freeze` to ensure this constacnt cannot be updated anywhere else.
> - We use [ActiveRecord::Store](https://api.rubyonrails.org/classes/ActiveRecord/Store.html) to interface with the `features` column. This will allow us to call `@user.enable_post_meta_description` instead of `user.features.enable_post_meta_description`. By passing `User::FEATURES` into the `accessors` parameter we can continue to add new features in the `FEATURES` constant.

## Step 2: Install Pundit

Next we'll need to install and configure [pundit](https://github.com/varvet/pundit).

1. Install [pundit](https://github.com/varvet/pundit).

```
bundle add pundit
```

3. Generate the base pundit files.

```
rails g pundit:install
```
