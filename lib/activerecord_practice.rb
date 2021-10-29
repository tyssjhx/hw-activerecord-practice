require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.
  
  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    return Customer.where(first: "Candice");
  end
  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    return Customer.where("email LIKE '%@%'");
  end
  # etc. - see README.md for more details
  def self.with_dot_org_email
    return Customer.where("email LIKE '%@%.org'");
  end

  def self.with_invalid_email
    return Customer.where("email NOT LIKE '%@%'");
  end

  def self.with_blank_email
    return Customer.where(email: nil);
  end

  def self.born_before_1980
    return Customer.where("birthdate < '1980-01-01'");
  end

  def self.with_valid_email_and_born_before_1980
    return Customer.where("email LIKE '%@%' AND birthdate < '1980-01-01'");
  end

  def self.last_names_starting_with_b
    return Customer.where("last LIKE 'B%'").order(:birthdate);
  end

  def self.twenty_youngest
    return Customer.order(birthdate: :desc).limit(20);
  end

  def self.update_gussie_murray_birthdate    
    user = Customer.find_by(first: 'Gussie');
    user.update(birthdate: '2004-02-08');
  end

  def self.change_all_invalid_emails_to_blank
    Customer.where("email NOT LIKE '%@%'").find_each do |user|
      user.update(email: "");
    end
  end
  
  def self.delete_meggie_herman
    user = Customer.find_by(:first => 'Meggie', :last => 'Herman');
    user.destroy
  end

  def self.delete_everyone_born_before_1978
    Customer.where('birthdate < ?', Time.parse("1 January 1978")).find_each do |user|
      user.destroy
    end
  end
end
