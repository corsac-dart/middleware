part of corsac_middleware;

/// Represents pipeline execution queue.
///
/// Each time [Pipeline] handling is executed we create queue of middleware handlers
/// and store it in the instance of this class which is passed from one handler to
/// another.
class Next {
  Queue<Middleware> _handlers;
  Next(this._handlers);

  Future<HandleContext> handle(HttpRequest request, HandleContext context) {
    if (this._handlers.isEmpty) {
      return new Future.value(context);
    } else {
      Middleware handler = this._handlers.removeFirst();
      return handler.handle(request, context, this);
    }
  }
}

/// Represents a pipeline of middleware handlers.
class Pipeline {
  List<Middleware> handlers;

  /// Pipeline constructor.
  Pipeline(this.handlers);

  /// Executes middleware pipeline and returns resulting [HandleContext].
  Future<HandleContext> handle(HttpRequest request) {
    Queue queue = new Queue.from(this.handlers);
    Next next = new Next(queue);
    HandleContext context = new HandleContext.empty();
    return next.handle(request, context);
  }
}
