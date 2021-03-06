class ProdutoVendasController < ApplicationController
  before_action :get_venda
  before_action :set_produto_venda, only: [:show, :edit, :update, :destroy]

  # GET /produto_vendas
  # GET /produto_vendas.json
  def index
    @produto_vendas = @venda.produto_vendas
  end

  # GET /produto_vendas/1
  # GET /produto_vendas/1.json
  def show
  end

  # GET /produto_vendas/new
  def new
    @produto_venda = @venda.produto_vendas.build
    @todos_produtos = Produto.all
    @produtos = []
    @todos_produtos.each do |pp|
      nome = pp.nome
      id = pp.id
      @produtos.push([nome, id])
    end
  end

  # GET /produto_vendas/1/edit
  def edit
  end

  # POST /produto_vendas
  # POST /produto_vendas.json
  def create
    @mensagem = ""
    @produto_venda = @venda.produto_vendas.build(produto_venda_params)
    if @produto_venda.produto.qtd_estoque > 0
      if !@produto_venda.qtd_produtos.nil?
        if (@produto_venda.produto.qtd_estoque - @produto_venda.qtd_produtos) > 0
          respond_to do |format|
            if @produto_venda.save
              ProdutoVenda.update(@produto_venda.id, :valor => @produto_venda[:qtd_produtos].to_f * @produto_venda.produto.preco.to_f )
              Venda.update(@venda.id, :valor => @venda[:valor].to_f + (@produto_venda[:qtd_produtos].to_f * @produto_venda.produto.preco.to_f))
              format.html { redirect_to @venda, notice: 'Produto adicionado com sucesso.' }
              format.json { render :show, status: :created, location: @produto_venda }
            else
              format.html { render :new }
              format.json { render json: @produto_venda.errors, status: :unprocessable_entity }
            end
          end
        else
          redirect_to new_venda_produto_venda_path(@venda), notice: "Quantidade de produto excede a quantidade em estoque."
        end
      else
        redirect_to new_venda_produto_venda_path(@venda), notice: "Campo quantidade de produtos deve ser preenchido."
      end
    else
      redirect_to new_venda_produto_venda_path(@venda), notice: "Produto em falta no estoque."
    end
  end

  # PATCH/PUT /produto_vendas/1
  # PATCH/PUT /produto_vendas/1.json
  def update
    respond_to do |format|
      if @produto_venda.update(produto_venda_params)
        Venda.update(@venda.id, :valor => @venda[:valor].to_f - @produto_venda[:valor].to_f)
        ProdutoVenda.update(@produto_venda.id, :valor => @produto_venda[:qtd_produtos].to_f * @produto_venda.produto.preco.to_f )
        Venda.update(@venda.id, :valor => @venda[:valor].to_f + @produto_venda[:valor].to_f)
        format.html { redirect_to @venda, notice: 'Produto editado com sucesso.' }
        format.json { render :show, status: :ok, location: @produto_venda }
      else
        format.html { render :edit }
        format.json { render json: @produto_venda.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /produto_vendas/1
  # DELETE /produto_vendas/1.json
  def destroy
    @produto_venda.destroy
    Venda.update(@venda.id, :valor => @venda[:valor].to_f - @produto_venda[:valor].to_f)
    respond_to do |format|
      format.html { redirect_to @venda, notice: 'Produto removido com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_produto_venda
      @produto_venda = @venda.produto_vendas.where("id = ?", params[:id]).first
    end

    # Only allow a list of trusted parameters through.
    def produto_venda_params
      params.require(:produto_venda).permit(:produto_id, :venda_id, :qtd_produtos, :valor)
    end

  def get_venda
    @venda = Venda.find(params[:venda_id])
  end

end
