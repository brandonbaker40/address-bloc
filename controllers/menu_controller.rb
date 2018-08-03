require_relative '../models/address_book'

class MenuController
  attr_reader :address_book

  def initialize
    @address_book = AddressBook.first
  end

  def main_menu
    puts "#{@address_book.name} Address Book - #{Entry.count} entries"
    puts "1 - View all entries"
    puts "2 - Create an entry"
    puts "3 - Search for an entry"
    puts "4 - Import entries from a CSV"
    puts "5 - Exit"
    puts "6 - Find in batches"
    puts "7 - Find each"
    print "Enter your selection: "

    selection = gets.to_i

    case selection
      when 1
        system "clear"
        view_all_entries
        main_menu
      when 2
        system "clear"
        create_entry
        main_menu
      when 3
        system "clear"
        search_entries
        main_menu
      when 4
        system "clear"
        read_csv
        main_menu
      when 5
        puts "Good-bye!"
        exit(0)
      when 6
        system "clear"
        search_in_batches
        main_menu
      when 7
        system "clear"
        search_each
        main_menu
      else
        system "clear"
        puts "Sorry, that is not a valid input"
        main_menu
    end
  end

  def view_all_entries
    Entry.all.each do |entry|
      system "clear"
      puts entry.to_s
      entry_submenu(entry)
    end

    system "clear"
    puts "End of entries"
  end

  def create_entry
    system "clear"
    puts "New AddressBloc Entry"
    print "Name: "
    name = gets.chomp
    print "Phone number: "
    phone = gets.chomp
    print "Email: "
    email = gets.chomp

    address_book.add_entry(name, phone, email)

    system "clear"
    puts "New entry created"
  end

  def search_entries
    print "Search by name: "
    name = gets.chomp
    match = Entry.find_by(:name, name)
    # ATTN Grader: see next line
    # match = Entry.find_by_name(name)
    system "clear"
    if match
      puts match.to_s
      search_submenu(match)
    else
      puts "No match found for #{name}"
    end
  end

  def search_in_batches
    print "Which entry should I start at?"
    start = gets.chomp
    print "What is the bach size?"
    batch_size = gets.chomp

    Entry.find_in_batches(start: start, batch_size: batch_size) do |entries, batch|
      entries.each { |entry| yield entry }
    end

    go_back
  end

  def search_each
    print "Which entry should I start at?"
    start = gets.chomp
    print "What is the bach size?"
    batch_size = gets.chomp

    Entry.find_each(:start => start, :batch_size => batch_size) do |entry|
      yield entry
    end

    go_back
  end

  def read_csv
    print "Enter CSV file to import: "
    file_name = gets.chomp

    if file_name.empty?
      system "clear"
      puts "No CSV file read"
      main_menu
    end

    begin
      entry_count = address_book.import_from_csv(file_name).count
      system "clear"
      puts "#{entry_count} new entries added from #{file_name}"
    rescue
      puts "#{file_name} is not a valid CSV file, please enter the name of a valid CSV file"
      read_csv
    end
  end

  def entry_submenu(entry)
    puts "n - next entry"
    puts "d - delete entry"
    puts "e - edit this entry"
    puts "m - return to main menu"

    selection = gets.chomp

    case selection
      when "n"
      when "d"
        delete_entry(entry)
      when "e"
        edit_entry(entry)
        entry_submenu(entry)
      when "m"
        system "clear"
        main_menu
      else
        system "clear"
        puts "#{selection} is not a valid input"
        entry_submenu(entry)
    end
  end

  def delete_entry(entry)
    address_book.entries.delete(entry)
    puts "#{entry.name} has been deleted"
  end

  def edit_entry(entry)
    print "Updated name: "
    name = gets.chomp
    print "Updated phone number: "
    phone_number = gets.chomp
    print "Updated email: "
    email = gets.chomp
    entry.name = name if !name.empty?
    entry.phone_number = phone_number if !phone_number.empty?
    entry.email = email if !email.empty?
    system "clear"
    puts "Updated entry:"
    puts entry
  end

  def search_submenu(entry)
    puts "\nd - delete entry"
    puts "e - edit this entry"
    puts "m - return to main menu"
    selection = gets.chomp

    case selection
      when "d"
        system "clear"
        delete_entry(entry)
        main_menu
      when "e"
        edit_entry(entry)
        system "clear"
        main_menu
      when "m"
        system "clear"
        main_menu
      else
        system "clear"
        puts "#{selection} is not a valid input"
        puts entry.to_s
        search_submenu(entry)
    end
  end

  def go_back
    puts "m - return to main menu"
    selection = gets.chomp

    case selection
      when "m"
        system "clear"
        main_menu
    end
  end

  # def view_all_entries
  #   system "clear"
  #   print "There are #{Entry.count} entries here. How many entries should each batch contain?"
  #   puts ""
  #   batch_size = gets.to_i
  #
  #   if batch_size.to_i.is_a?(Integer) && batch_size.to_i > 0
  #     print "Okay, now how many entries should we offset? Enter 0 if you don't care."
  #     puts ""
  #     start = gets.to_i
  #
  #     if start.to_i.is_a?(Integer) && (start.to_i < "#{Entry.count}".to_i)
  #       #Entry.find_each(start: start, batch_size: batch_size)
  #       Entry.find_in_batches(start: start, batch_size: batch_size)
  #     else
  #       puts "Let's start over."
  #       view_all_entries
  #     end
  #
  #   else
  #     raise "Not valid input."
  #     main_menu
  #   end
  #
  #   #
  #   # Entry.all.each do |entry|
  #   #   system "clear"
  #   #   puts entry.to_s
  #   #   entry_submenu(entry)
  #   # end
  #
  #   system "clear"
  #   puts "End of entries"
  # end
end
