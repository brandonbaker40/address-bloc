require_relative '../models/address_book'
 require_relative '../models/entry'
 require 'bloc_record'

 #BlocRecord.connect_to('db/address_bloc.sqlite', :sqlite3)
 BlocRecord.connect_to('db/address_bloc.db', :pg)


 book = AddressBook.create(name: 'My Address Book')

 puts 'Address Book created'
 puts 'Entry created'
 puts Entry.create(address_book_id: book.id, name: 'Bobby Smith', phone_number: '999-999-9999', email: 'foo_one@gmail.com' )
 puts Entry.create(address_book_id: book.id, name: 'Mike Ditka', phone_number: '111-111-1111', email: 'foo_two@gmail.com' )
 puts Entry.create(address_book_id: book.id, name: 'Bobby Smith', phone_number: '222-222-2222', email: 'foo_three@gmail.com' )
 puts Entry.create(address_book_id: book.id, name: 'Foo Bar Champ', phone_number: '333-333-3333', email: 'foo_four@gmail.com' )
 puts Entry.create(address_book_id: book.id, name: 'Jack Freeman', phone_number: '444-444-4444', email: 'foo_five@gmail.com' )
 puts Entry.create(address_book_id: book.id, name: 'Bill Freeman', phone_number: '555-555-5555', email: 'foo_six@gmail.com' )
 puts Entry.create(address_book_id: book.id, name: 'Steve Dean', phone_number: '666-666-6666', email: 'foo_seven@gmail.com' )
 puts Entry.create(address_book_id: book.id, name: 'Bobby Johnson', phone_number: '777-777-7777', email: 'foo_eight@gmail.com' )
 puts Entry.create(address_book_id: book.id, name: 'Timmy Thompson', phone_number: '888-888-8888', email: 'foo_nine@gmail.com' )
