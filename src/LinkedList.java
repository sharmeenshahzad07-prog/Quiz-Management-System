import java.util.*;

public class LinkedList<T> implements List<T> {

    public static class Node<T> {
        T data;
        Node<T> next;

        public Node(T data) {
            this.data = data;
            this.next = null;
        }
    }

    private Node<T> head;
    private Node<T> tail;
    private int size;

    public LinkedList() {
        head = null;
        tail = null;
        size = 0;
    }

public Node<T> getHead() {
    return head;
}


    @Override
    public boolean add(T data) {
        Node<T> newNode = new Node<>(data);
        if (head == null) {
            head = tail = newNode;
        } else {
            tail.next = newNode;
            tail = newNode;
        }
        size++;
        return true;
    }


    @Override
    public void add(int index, T data) {
        if (index < 0 || index > size) throw new IndexOutOfBoundsException();

        Node<T> newNode = new Node<>(data);

        if (index == 0) {
            newNode.next = head;
            head = newNode;
            if (size == 0) tail = head;
        } else {
            Node<T> prev = head;
            for (int i = 0; i < index - 1; i++) prev = prev.next;
            newNode.next = prev.next;
            prev.next = newNode;
            if (newNode.next == null) tail = newNode;
        }

        size++;
    }

   
    @Override
    public T remove(int index) {
        if (index < 0 || index >= size) throw new IndexOutOfBoundsException();
        Node<T> removed;

        if (index == 0) {
            removed = head;
            head = head.next;
            if (head == null) tail = null;
        } else {
            Node<T> prev = head;
            for (int i = 0; i < index - 1; i++) prev = prev.next;
            removed = prev.next;
            prev.next = removed.next;
            if (prev.next == null) tail = prev;
        }

        size--;
        return removed.data;
    }

    @Override
    public boolean remove(Object data) {
        if (head == null) return false;

        if (head.data == null ? data == null : head.data.equals(data)) {
            head = head.next;
            if (head == null) tail = null;
            size--;
            return true;
        }

        Node<T> prev = head;
        Node<T> curr = head.next;

        while (curr != null) {
            if (curr.data == null ? data == null : curr.data.equals(data)) {
                prev.next = curr.next;
                if (curr.next == null) tail = prev;
                size--;
                return true;
            }
            prev = curr;
            curr = curr.next;
        }

        return false;
    }

    @Override
    public T get(int index) {
        if (index < 0 || index >= size) throw new IndexOutOfBoundsException();

        Node<T> curr = head;
        for (int i = 0; i < index; i++) curr = curr.next;

        return curr.data;
    }

    @Override
    public int size() {
        return size;
    }

    @Override
    public boolean isEmpty() {
        return size == 0;
    }

    @Override
    public boolean contains(Object o) {
        Node<T> curr = head;
        while (curr != null) {
            if (curr.data == null ? o == null : curr.data.equals(o)) return true;
            curr = curr.next;
        }
        return false;
    }

    @Override
    public void clear() {
        head = tail = null;
        size = 0;
    }

    @Override
    public Iterator<T> iterator() {
        return new Iterator<T>() {
            private Node<T> current = head;
            private Node<T> lastReturned = null;

            @Override
            public boolean hasNext() { return current != null; }

            @Override
            public T next() {
                if (current == null) throw new NoSuchElementException();
                lastReturned = current;
                T data = current.data;
                current = current.next;
                return data;
            }

            @Override
            public void remove() {
                if (lastReturned == null) throw new IllegalStateException();
                LinkedList.this.remove(lastReturned.data);
                lastReturned = null;
            }
        };
    }

    @Override
    public Object[] toArray() {
        Object[] arr = new Object[size];
        int i = 0;
        Node<T> curr = head;
        while (curr != null) { arr[i++] = curr.data; curr = curr.next; }
        return arr;
    }

    @Override
    public <E> E[] toArray(E[] a) {
        if (a.length < size) {
            @SuppressWarnings("unchecked")
            E[] arr = (E[]) java.lang.reflect.Array.newInstance(a.getClass().getComponentType(), size);
            a = arr;
        }
        int i = 0;
        Node<T> curr = head;
        while (curr != null) { @SuppressWarnings("unchecked") E e = (E) curr.data; a[i++] = e; curr = curr.next; }
        if (a.length > size) a[size] = null;
        return a;
    }

    @Override
    public boolean addAll(Collection<? extends T> c) {
        boolean changed = false;
        for (T e : c) changed |= add(e);
        return changed;
    }

    @Override
    public boolean addAll(int index, Collection<? extends T> c) {
        if (index < 0 || index > size) throw new IndexOutOfBoundsException();
        boolean changed = false;
        int i = index;
        for (T e : c) { add(i++, e); changed = true; }
        return changed;
    }

    @Override
    public boolean removeAll(Collection<?> c) {
        boolean changed = false;
        Iterator<T> it = iterator();
        while (it.hasNext()) {
            if (c.contains(it.next())) { it.remove(); changed = true; }
        }
        return changed;
    }

    @Override
    public boolean retainAll(Collection<?> c) {
        boolean changed = false;
        Iterator<T> it = iterator();
        while (it.hasNext()) {
            if (!c.contains(it.next())) { it.remove(); changed = true; }
        }
        return changed;
    }

    @Override
    public boolean containsAll(Collection<?> c) {
        for (Object o : c) if (!contains(o)) return false;
        return true;
    }

    @Override
    public T set(int index, T element) {
        if (index < 0 || index >= size) throw new IndexOutOfBoundsException();
        Node<T> curr = head;
        for (int i = 0; i < index; i++) curr = curr.next;
        T old = curr.data;
        curr.data = element;
        return old;
    }

    @Override
    public int indexOf(Object o) {
        Node<T> curr = head; int idx = 0;
        while (curr != null) {
            if (curr.data == null ? o == null : curr.data.equals(o)) return idx;
            curr = curr.next; idx++;
        }
        return -1;
    }

    @Override
    public int lastIndexOf(Object o) {
        Node<T> curr = head; int idx = 0; int last = -1;
        while (curr != null) {
            if (curr.data == null ? o == null : curr.data.equals(o)) last = idx;
            curr = curr.next; idx++;
        }
        return last;
    }

    @Override
    public ListIterator<T> listIterator() { throw new UnsupportedOperationException(); }

    @Override
    public ListIterator<T> listIterator(int index) { throw new UnsupportedOperationException(); }

    @Override
    public List<T> subList(int fromIndex, int toIndex) { throw new UnsupportedOperationException(); }

}
