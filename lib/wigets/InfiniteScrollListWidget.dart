import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news/model/presentation_models.dart';

class InfiniteScrollListWidget<T> extends StatefulWidget {
  final LoadedData<T> _initialItems;
  final Widget Function(T) _onCreateItem;
  final Future<List<T>> Function(int) _onLoadMore;

  InfiniteScrollListWidget(this._initialItems,
      this._onCreateItem,
      this._onLoadMore,);

  @override
  _InfiniteScrollListState<T> createState() =>
      _InfiniteScrollListState<T>(_initialItems, _onCreateItem, _onLoadMore);
}

class _InfiniteScrollListState<T> extends State<InfiniteScrollListWidget> {
  final LoadedData<T> initialItems;
  final Widget Function(T) onCreateItem;
  final Future<List<T>> Function(int) onLoadMore;

  ScrollController _controller =
  ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

  List<T> items = [];

  int currentPage = 1;

  bool isLoading = false;

  _InfiniteScrollListState(this.initialItems,
      this.onCreateItem,
      this.onLoadMore,) {
    items.addAll(initialItems.dataBatch);

    _controller.addListener(() {
      bool isEnd = _controller.offset == _controller.position.maxScrollExtent;
      if (isEnd && !isLoading && items.length < initialItems.total)
        setState(() {
          _loadMoreItems();
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _getScreenWidget();
  }

  Widget _getScreenWidget() {
    return ListView.builder(
      controller: _controller,
      itemCount:
      items.length == initialItems.total ? items.length : items.length + 1,
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

  _loadMoreItems() async {
    setState(() {
      isLoading = true;
    });

    var newItems = await onLoadMore(++currentPage);

    setState(() {
      isLoading = false;
      items.addAll(newItems);
    });
  }
}
