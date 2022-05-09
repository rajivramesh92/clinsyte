class Paginate {

    constructor(requestOptions, responseHolder, pushTo, callback) {

      this.requestOptions = requestOptions;
      this.pushTo = pushTo;
      this.isComplete = false;
      this.callback = callback;
      this.responseHolder = responseHolder;

      this._pageCount = 0;
      this._queue = [];
      this._isBusy  = false;

      this.next();
    }

    next() {
      if(this.isComplete) {
        return;
      }
      if(this._isBusy) {
        this._queue.push(this._queue.length == 0 ? this._pageCount + 1 : this._queue[this._queue.legth] + 1 )
        return;
      }
      this._isBusy = true;
      this._pageCount++;
      var obj = this;
      request({
        data: { page: this._pageCount },
        ...this.requestOptions
       })
      .then(response => {
        var responseData = response.data.data[this.responseHolder] || response.data.data;
        if(responseData.length < 10) {
          obj.isComplete = true;
        }
        if(responseData) {
          obj.callback(responseData)
        }
        if(this._queue.length > 0) {
          obj._isBusy = false;
          _queue.shift();
          obj.next();
        }
        obj._isBusy = false;
      })
    }
}
