class GoodReadsJob < Job
  @period = '1d'

  def self.auth_hash
    { user_id: ENV["GOOD_READS_USER_ID"],
      api_key: ENV["GOOD_READS_API_KEY"],
      api_secret: ENV["GOOD_READS_API_SECRET"] }
  end

  def self.perform_job
    super
    good_read_job = JobHelpers::GoodReadsJob.new(auth_hash, logger)
    books = good_read_job.shelf("read").books
    good_read_job.save_books_and_authors(books)

    send_event('good_reads_recent_books', books: good_read_job.book_hashes(books))
  end
end

GoodReadsJob.run
