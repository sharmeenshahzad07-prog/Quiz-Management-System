
class DSNode<T> {
    T data;
    DSNode<T> next;

    DSNode(T data) {
        this.data = data;
        this.next = null;
    }
}

class StackDS<T> {
    private DSNode<T> top;

    public StackDS() {
        top = null;
    }

    public void push(T value) {
        DSNode<T> newNode = new DSNode<>(value);
        newNode.next = top;
        top = newNode;
    }

    public T pop() {
        if (isEmpty()) return null;
        T value = top.data;
        top = top.next;
        return value;
    }

    public T peek() {
        if (isEmpty()) return null;
        return top.data;
    }

    public boolean isEmpty() {
        return top == null;
    }
}

public class QueueDS<T> {
    private DSNode<T> front, rear;

    public QueueDS() {
        front = rear = null;
    }

    public void enqueue(T value) {
        DSNode<T> newNode = new DSNode<>(value);
        if (rear == null) {
            front = rear = newNode;
            return;
        }
        rear.next = newNode;
        rear = newNode;
    }

    public T dequeue() {
        if (isEmpty()) return null;
        T value = front.data;
        front = front.next;
        if (front == null) rear = null;
        return value;
    }

    public boolean isEmpty() {
        return front == null;
    }
}