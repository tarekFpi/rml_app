class ResourceUiState<T> {
  Status state;
  T? data;
  String? message;

  ResourceUiState({this.state = Status.IDEAL});

  ResourceUiState.loading({this.message}) : state = Status.LOADING;

  ResourceUiState.success({this.data}) : state = Status.SUCCESS;

  ResourceUiState.error(this.message) : state = Status.ERROR;

  ResourceUiState.empty({this.data}) : state = Status.EMPTY;
}

enum Status { IDEAL, LOADING, SUCCESS, ERROR, EMPTY }