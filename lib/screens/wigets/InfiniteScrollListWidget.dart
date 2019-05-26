import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InfiniteScrollListWidget<T> extends StatefulWidget {

  final Future<LoadData<T>> Function(int) onLoadMore;
  final Future<LoadData<T>> Function() onInitialLoad;
  final Widget Function(T) onCreateItem;

  InfiniteScrollListWidget(this.onLoadMore, this.onInitialLoad,
      this.onCreateItem);

  @override
  _InfiniteScrollListState<T> createState() =>
      _InfiniteScrollListState<T>(onLoadMore, onInitialLoad, onCreateItem);
}

class _InfiniteScrollListState<T> extends State<InfiniteScrollListWidget> {

  final Future<LoadData<T>> Function(int) onLoadMore;
  final Future<LoadData<T>> Function() onInitialLoad;
  final Widget Function(T) onCreateItem;

  ScrollController _controller =
  ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  List<T> items = [];

  int _total = -1;

  int currentPage = 0;
  bool isLoading = false;

  _InfiniteScrollListState(this.onLoadMore, this.onInitialLoad,
      this.onCreateItem) {
    _controller.addListener(() {
      bool isEnd = _controller.offset == _controller.position.maxScrollExtent;
      if (isEnd && items.length < _total)
        setState(() {
          onLoadMore(currentPage);
        });
    });
  }

  @override
  void initState() {
    super.initState();

    _loadData(() => onInitialLoad());
  }

  @override
  Widget build(BuildContext context) {
    return _getScreenWidget();
  }

  Widget _getScreenWidget() {
    if (isLoading && currentPage == 1) {
      return Center(child: CircularProgressIndicator());
      onInitialLoad()
    } else {
      return ListView.builder(
        controller: _controller,
        itemCount: items.length == _total ? items.length : items.length + 1,
        itemBuilder: (context, index) {
          if (index == items.length) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              ),
            );
          } else {
            T item = items[index];
            return onCreateItem(item);
          }
        },
      );
    }
  }

  _loadData(Future<LoadData<T>> Function() dataSource) async {
    setState(() {
      isLoading = true;
    });

    currentPage++;
    var data = await dataSource();

    setState(() {
      isLoading = false;

      _total = data.total;
      items.addAll(data.dataBatch);
    });
  }
}

class LoadData<T> {

  final List<T> dataBatch;
  final int total;

  LoadData(this.dataBatch, this.total);
}