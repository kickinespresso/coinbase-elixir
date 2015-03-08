defmodule Coinbase.API.Accounts do
  alias Coinbase.API.Base
  import Coinbase.Util.Params

  @endpoint "accounts"
  @data_struct Coinbase.Account
  @address_struct Coinbase.Address
  @collection_name String.to_atom(@endpoint)

  @doc """
  Gets a list of accounts

  Optional params:
    page (integer): Can be used to page through results. Default value is 1.
    limit (integer): Number of records to return. Maximum is 1000. Default value is 25.
    all_accounts (integer): Set this to true to also list inactive accounts.
  """
  @spec list(pid, map) :: Coinbase.response
  def list(coinbase, optionals \\ %{}) do
    params = add_optionals(%{}, optionals)
    Base.list(coinbase, @endpoint, params, @data_struct, @collection_name)
  end

  @doc """
  Gets an account
  """
  @spec get(pid, binary) :: Coinbase.response
  def get(coinbase, id) do
    Base.get(coinbase, @endpoint, id, @data_struct, @collection_name)
  end

  @doc """
  Create an account (supports multisig)

  Optional params:
    account[type] (string): Type of account. If creating a HDM (multisig) account, specify multisig.
    account[m] (string): Number of required signatures to spend from HDM multisig account.
    account[xpubkeys] (array): Array of extended public keys of BIP32 wallets. Length of array must be greater or equal than 'm' to create a complete account.
  """
  @spec create(pid, binary, map) :: Coinbase.response
  def create(coinbase, name, optionals \\ %{}) do
    params = %{account: %{name: name}}
    params = add_optionals(params, optionals)
    Base.post(coinbase, @endpoint, params, @data_struct, @collection_name)
  end

  @doc """
  Get an account's balance
  """
  @spec get_balance(pid, binary) :: Coinbase.response
  def get_balance(coinbase, id) do
    Base.get(coinbase, "#{@endpoint}/#{id}/balance", @data_struct, @collection_name)
  end

  @doc """
  Get an accounts bitcoin address
  """
  @spec get_address(pid, binary) :: Coinbase.response
  def get_address(coinbase, id) do
    Base.get(coinbase, "#{@endpoint}/#{id}/address", @data_struct, @collection_name)
  end

  @doc """
  Create a new bitcoin address for an account
  """
  @spec create_address(pid, binary,  map) :: Coinbase.response
  def create_address(coinbase, account_id, optionals \\ %{}) do
    params = add_optionals(%{}, optionals)
    Base.post(coinbase, "#{@endpoint}/#{account_id}/address", params, @address_struct, @collection_name)
  end

  @doc """
  Updates a account
  """
  @spec update(pid, map) :: Coinbase.response
  def update(coinbase, account) do
    Base.put(coinbase, "#{@endpoint}/#{account.id}", account, @data_struct, @collection_name)
  end

  @doc """
  Set account as primary
  """
  @spec set_primary(pid, binary) :: Coinbase.response
  def set_primary(coinbase, id) do
    Base.post(coinbase, "#{@endpoint}/#{id}/primary", @data_struct, @collection_name)
  end

  @doc """
  Delete an account (only non-primary accounts with zero balance)
  """
  @spec delete(pid, binary) :: Coinbase.response
  def delete(coinbase, id) do
    Base.delete(coinbase, @endpoint, id, @data_struct, @collection_name)
  end
end