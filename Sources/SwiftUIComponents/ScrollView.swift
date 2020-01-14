import SwiftUI

public struct ScrollView<Content: View>: View {
    private let axes: Axis.Set
    private let showIndicators: Bool
    @Binding private var contentOffset: CGFloat
    private let content: Content

    public init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        contentOffset: Binding<CGFloat>,
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showIndicators = showsIndicators
        self._contentOffset = contentOffset
        self.content = content()
    }

    private func calculateOffset(inner: GeometryProxy, outer: GeometryProxy) -> CGFloat {
        if self.axes == .horizontal {
            return inner.frame(in: .global).origin.x - outer.frame(in: .global).origin.x
        } else {
            return inner.frame(in: .global).origin.y - outer.frame(in: .global).origin.y
        }
    }

    public var body: some View {
        GeometryReader { outerGeometry in
            SwiftUI.ScrollView(
                self.axes,
                showsIndicators: self.showIndicators
            ) {
                ZStack(alignment: self.axes == .vertical ? .top : .leading) {
                    self.content
                    GeometryReader { innerGeometry in
                        Color
                            .clear
                            .preference(
                                key: Offset.self,
                                value: self.calculateOffset(inner: innerGeometry, outer: outerGeometry)
                        )
                    }.onPreferenceChange(Offset.self) { value in
                        self.contentOffset = value
                    }
                }
            }
        }
    }
}
