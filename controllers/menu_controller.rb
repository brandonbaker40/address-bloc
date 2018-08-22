require_relative '../models/address_book'

class MenuController
  attr_reader :address_book

  def initialize
    @address_book = AddressBook.first
  end

  def main_menu
    # puts "#{@address_book.name} Address Book Selected\n#{@address_book.entries.count} entries"
    puts "0 - Switch AddressBook"
    puts "1 - View all entries"
    puts "2 - Create an entry"
    puts "3 - Search for an entry"
    puts "4 - Import entries from a CSV"
    puts "5 - Exit"
    puts "6 - Find in batches"
    puts "7 - Find each"
    puts "8 - Bulk edit entries"
    puts "9 - Destroy all of it!!!"
    print "Enter your selection: "

    selection = gets.to_i

    case selection
      when 0
        system "clear"
        select_address_book_menu
        main_menu
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
      when 8
        system "clear"
        bulk_edit_entries
        main_menu
      when 9
        system "clear"
        destroy_everything
        main_menu
      else
        system "clear"
        puts "Sorry, that is not a valid input"
        main_menu
    end
  end

  def select_address_book_menu
    puts "Select an Address Book:"
    AddressBook.all.each_with_index do |address_book, index|
      puts "#{index} - #{address_book.name}"
    end

    index = gets.chomp.to_i

    @address_book = AddressBook.find(index + 1)
    system "clear"
    return if @address_book
    puts "Please select a valid index"
    select_address_book_menu
  end

  def view_all_entries
    puts "How do you wanted them sorted? You can choose from these:"
    puts "#{Entry.columns.to_a}"
    selection = gets.chomp

    # temporary storage
    old_address_book = @address_book

    @address_book = Entry.order(selection)

    @address_book.entries.each do |entry|
      system "clear"
      puts entry.to_s
      entry_submenu(entry)
    end

    # reset address_book back to its presorted version
    @address_book = old_address_book

    system "clear"
    puts "End of entries"
    main_menu
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

    match = @address_book.find_entry(name)

    # keep next line for select methods checkpoint
    # match = Entry.find_by(:name, name)
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
    entry.destroy
    puts "#{entry.name} has been deleted"
  end

  def edit_entry(entry)
    updates = {}
    print "Edit name: "
    name = gets.chomp
    updates[:name] = name unless name.empty?
    print "Edit phone number: "
    phone_number = gets.chomp
    updates[:phone_number] = phone_number unless phone_number.empty?
    print "Edit email: "
    email = gets.chomp
    updates[:email] = email unless email.empty?

    entry.update_attributes(updates)

    system "clear"
    puts "Updated entry:"
    puts Entry.find(entry.id)
    search_submenu(entry)
  end

  def bulk_edit_entries
    puts "Make updates to all records?"
    ids = gets.chomp

    # ids = ids.split(",").map(&:to_i)
    updates = {}

    print "What should be the value of name for all entries? If not, leave blank."
    name = gets.chomp
    updates[:name] = name unless name.empty?

    print "What should be the value of phone number for all entries? If not, leave blank."
    phone_number = gets.chomp
    updates[:phone_number] = phone_number unless phone_number.empty?

    print "What should be the value of email for all entries? If not, leave blank."
    email = gets.chomp
    updates[:email] = email unless email.empty?

    # My attempt to update just some records, not all of them! Grrrr...

    # Entry.columns.each do |column|
    #   if (column != "id") && (column != "address_book_id")
    #     print "What should be the value for \"#{column}\" for these ids #{ids}?"
    #     column = gets.chomp
    #     updates[:column] = column unless column.empty?
    #     print "#{updates[:column]} is getting updated"
    #   end
    # end

    # Entry.count.times do |id, updates|
    #   if ids.include? id.to_s
    #     Entry.update(id, updates)
    #   end
    # end

    Entry.update(ids, updates)
    system "clear"
    main_menu
  end

  def destroy_everything
    puts "Which ids are we going to get rid of? Don't put anything if you want to erase everything."
    ids = gets.chomp

    Entry.destroy_all(ids)
    system "clear"
    main_menu
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

end
