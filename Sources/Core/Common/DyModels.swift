import Foundation

public final class DyModel1<T1> {
    var item1: T1
    init(item1: T1) {
        self.item1 = item1
    }
}

public final class DyModel2<T1, T2> {
    var item1: T1
    var item2: T2
    init(item1: T1, item2: T2) {
        self.item1 = item1
        self.item2 = item2
    }
}

public final class DyModel3<T1, T2, T3> {
    var item1: T1
    var item2: T2
    var item3: T3
    init(item1: T1, item2: T2, item3: T3) {
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
    }
}

public final class DyModel4<T1, T2, T3, T4> {
    var item1: T1
    var item2: T2
    var item3: T3
    var item4: T4
    init(item1: T1, item2: T2, item3: T3, item4: T4) {
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
        self.item4 = item4
    }
}

public final class DyModel5<T1, T2, T3, T4, T5> {
    var item1: T1
    var item2: T2
    var item3: T3
    var item4: T4
    var item5: T5
    init(item1: T1, item2: T2, item3: T3, item4: T4, item5: T5) {
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
        self.item4 = item4
        self.item5 = item5
    }
}
