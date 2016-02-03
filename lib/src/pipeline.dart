part of corsac_middleware;

/// Represents pipeline execution queue.
///
/// Each time [Pipeline] handling is executed we create queue of middleware handlers
/// and store it in the instance of this class which is passed from one handler to
/// another.
class Next {
  Queue<Middleware> _handlers;
  Next(this._handlers);

  Future handle(HttpRequest request, Object context) {
    if (this._handlers.isEmpty) {
      return new Future.value();
    } else {
      Middleware handler = this._handlers.removeFirst();
      return handler.handle(request, context, this);
    }
  }
}

/// Represents a pipeline of middleware handlers.
///
/// The pipeline consists of 2 sections: `before` and `main`. The only
/// responsibility of these sections is to allow extending existing pipeline
/// instead of completly overriding it. This enables implementers to define
/// semantics for each section and provide guidelines to users on where to put
/// their own middlewares.
///
/// Common scenario would be if application framework puts it's handlers in the
/// `main` section and provides some "extension points" (via `context` object,
/// for instance) for users which can be used by handlers in the `before` section.
///
/// The pipeline itself does not distinguish between handlers in different
/// sections and composes single processing queue where `before` handlers
/// go first, following by `main`.
class Pipeline {
  final Set<Middleware> beforeHandlers = new Set();
  final Set<Middleware> mainHandlers;

  /// Pipeline constructor.
  Pipeline(this.mainHandlers);

  /// Executes middleware pipeline.
  Future handle(HttpRequest request, Object context) {
    Queue queue = new Queue.from(beforeHandlers)..addAll(mainHandlers);
    Next next = new Next(queue);

    return next.handle(request, context);
  }
}
