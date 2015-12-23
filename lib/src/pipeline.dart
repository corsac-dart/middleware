part of corsac_middleware;

/// Represents pipeline execution queue.
///
/// Each time [Pipeline] handling is executed we create queue of middleware handlers
/// and store it in the instance of this class which is passed from one handler to
/// another.
class Next {
  Queue<Middleware> _handlers;
  Next(this._handlers);

  HttpResponseContent handle(HttpRequest request, HttpResponseContent content) {
    if (this._handlers.isEmpty) {
      return content;
    } else {
      Middleware handler = this._handlers.removeFirst();
      return handler.handle(request, content, this);
    }
  }
}

/// Represents pipeline of middleware handlers.
///
/// This class is main entry point to the library.
class Pipeline {
  List<Middleware> handlers;

  /// Pipeline constructor.
  Pipeline(this.handlers);

  /// Executes middleware pipeline and returns resulting [HttpResponseContent].
  HttpResponseContent handle(HttpRequest request) {
    Queue queue = new Queue.from(this.handlers);
    Next next = new Next(queue);
    HttpResponseContent content = new HttpResponseContent.empty();
    return next.handle(request, content);
  }
}
