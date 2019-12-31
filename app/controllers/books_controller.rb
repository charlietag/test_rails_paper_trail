class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end

  # GET /books/destroyed
  # GET /books/destroyed.json
  def destroyed
    # This would never get record , because it's really been deleted...
    #@books = Book.joins(:audits).where( audits: {action: 'destroy'})

    # @books.class.name #->  ActiveRecord::Relation
    # @books.name       #->  Audited::Audit
    #
    # Still - better works with soft delete (discard), or this will cause record confusion
    #   ex. (below statement) Book id : 11 ---> show last history of record 11 (only destroy action)
    #@books = Audited::Audit.where( auditable_type: "Book").order(auditable_id: 'asc')
    @books = PaperTrail::Version.where( event: 'destroy', item_type: "Book").order(item_id: 'asc')

    # Still - better works with soft delete (discard), or this will cause record confusion
    #   ex. (below statement) Book id : 11 ---> show all history including CRUD
    #@books = Audited::Audit.where( auditable_type: "Book").order(auditable_id: 'asc')

    #render plain: @books.inspect
    render :index
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:name, :author, :year)
    end
end
