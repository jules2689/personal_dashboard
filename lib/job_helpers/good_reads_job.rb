require 'goodreads'

module JobHelpers
  class GoodReadsJob
    def initialize(args, logger)
      @user_id = args[:user_id]
      @api_key = args[:api_key]
      @api_secret = args[:api_secret]
      @logger = logger
    end

    def book_hashes(books)
      books.collect do |book|
        book = book.book
        author_names = book.authors.collect { |_a, v| v.name }.join(", ")
        {
          name: book.title,
          image: book.image_url,
          url: book.link,
          subtext: author_names
        }
      end.take(6)
    end

    # Api Handlers

    def user
      good_reads.user(@user_id)
    end

    def shelf(shelf_name)
      @logger.info "Fetching shelf #{shelf_name} for user #{@user_id}"
      good_reads.shelf(@user_id, shelf_name)
    end

    def good_reads
      @good_reads ||= Goodreads.new(api_key: @api_key, api_secret: @api_secret)
    end

    # Database Handlers

    def save_books_and_authors(books)
      @logger.info "Saving books and authors to the database"
      books.each do |book|
        hashie_book = book.book
        book = save_book(hashie_book)
        save_authors(hashie_book.authors, book)
      end
    end

    def save_book(hashie_book)
      book_hash = hashie_book.to_h
      book_hash.delete("authors")
      book = Book.find_or_initialize_by(remote_id: hashie_book.id)
      book.update(book_hash)
      book
    end

    def save_authors(authors, book)
      authors.each do |_key, hashie_author|
        author = Author.find_or_initialize_by(remote_id: hashie_author.id,
                                              book_id: book.id)
        author.update(hashie_author.to_h)
      end
    end
  end
end
