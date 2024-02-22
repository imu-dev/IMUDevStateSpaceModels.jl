"""
    NotImplExcpt(fn::String, t)

Simple exception to raise when a method `fn` is not implemented for a given
type `t`. (`t` passed to a constructor can be either a datatype or an instance
of it.)
"""
struct NotImplExcpt <: Exception
    fn::String
    type::DataType
end

NotImplExcpt(fn::String, t) = new(fn, typeof(t))
function Base.showerror(io::IO, e::NotImplExcpt)
    return print(io, e.var, "`$(e.fn)` not implemented for $(e.type)")
end